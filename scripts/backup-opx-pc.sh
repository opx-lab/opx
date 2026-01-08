#!/usr/bin/env bash
set -euo pipefail
cd /  # avoid getcwd() issues

ts="$(date +%Y-%m-%d-%H-%M)"
real_user="${SUDO_USER:-$(logname 2>/dev/null || echo root)}"
home_dir="$(getent passwd "$real_user" | cut -d: -f6)"
out_zip="${home_dir}/${ts}_opx-lab_backup.zip"

tmp="$(mktemp -d)"
stage="$tmp/stage"
trap 'rm -rf "$tmp"' EXIT

[[ "$(id -u)" -eq 0 ]] || { echo "run with sudo"; exit 1; }
command -v rsync >/dev/null && command -v zip >/dev/null

mkdir -p "$stage"/{pve,network,firewall,sysctl,apt-proxy,ssh,meta}

# copy readable export; deref symlinks (-L) by default
copy() {
  local cat="$1" src="$2"
  [[ -e "$src" ]] || return 0
  mkdir -p "$stage/$cat"
  rsync -aL --no-specials --no-devices \
    --chown="$real_user:$real_user" \
    --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r \
    "$src" "$stage/$cat/"
}

# copy but KEEP symlinks (no -L) — needed for apt-cacher-ng cache (can contain dangling links)
copy_keep_links() {
  local cat="$1" src="$2"
  [[ -e "$src" ]] || return 0
  mkdir -p "$stage/$cat"
  rsync -a --no-specials --no-devices \
    --chown="$real_user:$real_user" \
    --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r \
    "$src" "$stage/$cat/"
}

copy pve       /etc/pve
copy network   /etc/network
copy network   /etc/hosts
copy network   /etc/resolv.conf
copy firewall  /etc/ufw
copy firewall  /etc/iptables
copy sysctl    /etc/sysctl.conf
copy sysctl    /etc/sysctl.d
copy apt-proxy /etc/apt-cacher-ng
copy_keep_links apt-proxy /var/cache/apt-cacher-ng
copy ssh       /root/.ssh
copy ssh       /home/opx/.ssh

# drop sensitive Proxmox priv material
rm -rf "$stage/pve/etc/pve/priv" 2>/dev/null || true

# metadata
{
  echo "timestamp=$ts"
  echo "hostname=$(hostname -f 2>/dev/null || hostname)"
  echo "kernel=$(uname -r)"
  echo
  df -h
  echo
  ip a
  echo
  ip r
} > "$stage/meta/host_state.txt"

cd "$tmp"
zip -qr "$out_zip" stage
chown "$real_user:$real_user" "$out_zip" 2>/dev/null || true
chmod 644 "$out_zip"

echo "$out_zip"

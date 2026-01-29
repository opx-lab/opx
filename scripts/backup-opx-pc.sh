#!/usr/bin/env bash
set -euo pipefail
cd /  # important for rsync -R relative paths

ts="$(date +%Y-%m-%d-%H-%M)"
real_user="${SUDO_USER:-$(logname 2>/dev/null || echo root)}"
home_dir="$(getent passwd "$real_user" | cut -d: -f6)"
out_zip="${home_dir}/${ts}_opx-lab_backup.zip"

tmp="$(mktemp -d)"
stage="$tmp/stage"
trap 'rm -rf "$tmp"' EXIT

[[ "$(id -u)" -eq 0 ]] || { echo "run with sudo"; exit 1; }
command -v rsync >/dev/null
command -v zip   >/dev/null

mkdir -p "$stage"/{pve,network,firewall,sysctl,apt-proxy,ssh,meta}

# copy with dereferenced symlinks (-L), preserving full path under /
copy() {
  local cat="$1" src="$2"
  [[ -e "$src" ]] || return 0
  local rel="${src#/}"   # strip leading slash
  rsync -aRL --no-specials --no-devices \
    --chown="$real_user:$real_user" \
    --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r \
    "$rel" "$stage/$cat/"
}

# copy preserving symlinks (no -L), preserving full path under /
copy_keep_links() {
  local cat="$1" src="$2"
  [[ -e "$src" ]] || return 0
  local rel="${src#/}"
  rsync -aR --no-specials --no-devices \
    --chown="$real_user:$real_user" \
    --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r \
    "$rel" "$stage/$cat/"
}

# --- core system state ---
copy pve       /etc/pve
copy network   /etc/network
copy network   /etc/hosts
copy network   /etc/resolv.conf

# --- firewall (FULL UFW) ---
copy firewall  /etc/ufw
copy firewall  /etc/default/ufw
copy firewall  /etc/iptables

# --- sysctl ---
copy sysctl    /etc/sysctl.conf
copy sysctl    /etc/sysctl.d

# --- apt proxy ---
copy apt-proxy /etc/apt-cacher-ng
copy_keep_links apt-proxy /var/cache/apt-cacher-ng

# --- ssh keys ---
copy ssh       /root/.ssh
copy ssh       "$home_dir/.ssh"

# remove sensitive proxmox private material
rm -rf "$stage/pve/etc/pve/priv" 2>/dev/null || true

# --- metadata snapshots ---
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

{
  echo "==== ufw status verbose ===="
  ufw status verbose || true
  echo
  echo "==== ufw status numbered ===="
  ufw status numbered || true
  echo
  echo "==== ufw show raw ===="
  ufw show raw || true
} > "$stage/meta/ufw.txt"

# --- archive ---
cd "$tmp"
zip -qr "$out_zip" stage
chown "$real_user:$real_user" "$out_zip" 2>/dev/null || true
chmod 644 "$out_zip"

echo "$out_zip"


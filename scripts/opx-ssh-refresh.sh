#!/usr/bin/env bash
set -euo pipefail

INV="${1:-$HOME/opx-lab/opx-ansible/inventory/hosts.ini}"
KH="${2:-$HOME/.ssh/known_hosts_opxlab}"

# prep known_hosts file
mkdir -p "$(dirname "$KH")"
touch "$KH"
chmod 600 "$KH"

# get unique targets (host aliases + ansible_host IPs)
mapfile -t TARGETS < <(
  awk '
    /^[[:space:]]*#/ {next}
    /^[[:space:]]*$/ {next}
    /^\[/            {next}
    {
      print $1
      for (i=2; i<=NF; i++)
        if ($i ~ /^ansible_host=/) { split($i,a,"="); print a[2] }
    }' "$INV" | sort -u
)

# remove old keys then scan new ones
for t in "${TARGETS[@]}"; do ssh-keygen -f "$KH" -R "$t" >/dev/null 2>&1 || true; done
for t in "${TARGETS[@]}"; do ssh-keyscan -T 3 -H "$t" 2>/dev/null >> "$KH" || true; done

# dedupe
awk '!seen[$0]++' "$KH" > "${KH}.tmp" && mv "${KH}.tmp" "$KH"

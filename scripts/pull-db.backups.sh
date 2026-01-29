#!/bin/bash
set -euo pipefail

# Source (db-vm)
SRC_HOST="192.168.55.60"
SRC_USER="opx"
SRC_PATH="/var/backups/postgresql-export/pg_dumpall_*.sql.gz"

# Destination (opx-pc)
DEST_DIR="/home/opx/opx-lab/backups/database"
KEEP=4

# Ensure destination exists
mkdir -p "${DEST_DIR}"
chmod 0750 "${DEST_DIR}"

# Pull backups from db-vm (SSH as opx)
rsync -a --timeout=15 --chmod=F640 \
  "${SRC_USER}@${SRC_HOST}:${SRC_PATH}" \
  "${DEST_DIR}/"

# Retention: keep only newest KEEP files
ls -1t "${DEST_DIR}"/pg_dumpall_*.sql.gz 2>/dev/null \
  | tail -n +$((KEEP+1)) \
  | xargs -r rm -f --


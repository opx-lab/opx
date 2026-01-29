#!/usr/bin/env bash
set -euo pipefail

DB_HOST="${DB_HOST:-192.168.55.60}"
SSH_USER="${SSH_USER:-opx}"

BACKUP_DIR="${BACKUP_DIR:-/home/opx/opx-lab/backups/database}"
BACKUP_GLOB="${BACKUP_GLOB:-pg_dumpall_*.sql.gz}"

REMOTE_USER_DIR="${REMOTE_USER_DIR:-/home/opx/.cache/opx-restore}"
REMOTE_STAGE_DIR="${REMOTE_STAGE_DIR:-/tmp/opx-restore}"

VERIFY_DBS_REGEX="${VERIFY_DBS_REGEX:-opx_app|opx_jobs}"

latest_backup() {
  # NOTE: Do NOT quote the glob, otherwise '*' won't expand
  ls -1t ${BACKUP_DIR}/${BACKUP_GLOB} 2>/dev/null | head -1 || true
}

BK="$(latest_backup)"
if [[ -z "${BK}" || ! -f "${BK}" ]]; then
  echo "ERROR: No backups found in ${BACKUP_DIR}/${BACKUP_GLOB}" >&2
  echo "DEBUG: Listing ${BACKUP_DIR}:" >&2
  ls -lah "${BACKUP_DIR}" 2>/dev/null >&2 || true
  exit 1
fi

echo "Using backup: ${BK}"

# Ensure sudo works non-interactively on db-vm
ssh "${SSH_USER}@${DB_HOST}" "sudo -n true" >/dev/null

# Upload into user-writable directory on db-vm
ssh "${SSH_USER}@${DB_HOST}" "mkdir -p '${REMOTE_USER_DIR}' && chmod 0700 '${REMOTE_USER_DIR}'"
REMOTE_UPLOADED="${REMOTE_USER_DIR}/$(basename "${BK}")"

echo "Uploading to ${DB_HOST}:${REMOTE_UPLOADED}"
scp -q "${BK}" "${SSH_USER}@${DB_HOST}:${REMOTE_UPLOADED}"

# Stage for postgres: create dir owned by postgres so it can read the dump
REMOTE_DUMP="${REMOTE_STAGE_DIR}/dump.sql.gz"
ssh "${SSH_USER}@${DB_HOST}" "sudo -n mkdir -p '${REMOTE_STAGE_DIR}'"
ssh "${SSH_USER}@${DB_HOST}" "sudo -n chown postgres:postgres '${REMOTE_STAGE_DIR}'"
ssh "${SSH_USER}@${DB_HOST}" "sudo -n chmod 0700 '${REMOTE_STAGE_DIR}'"
ssh "${SSH_USER}@${DB_HOST}" "sudo -n install -o postgres -g postgres -m 0600 '${REMOTE_UPLOADED}' '${REMOTE_DUMP}'"

echo "Restoring on ${DB_HOST}..."
ssh "${SSH_USER}@${DB_HOST}" "sudo -n -u postgres bash -c '
set -euo pipefail
FILE=\"${REMOTE_DUMP}\"

gunzip -c \"\$FILE\" \
  | sed -E \
    -e \"/^DROP ROLE (IF EXISTS )?\\\"?postgres\\\"?;$/d\" \
    -e \"/^CREATE ROLE \\\"?postgres\\\"?;/d\" \
    -e \"/^ALTER ROLE \\\"?postgres\\\"? /d\" \
    -e \"/^DROP DATABASE (IF EXISTS )?\\\"?postgres\\\"?;$/d\" \
    -e \"/^CREATE DATABASE \\\"?postgres\\\"?.*$/d\" \
    -e \"/^ALTER DATABASE \\\"?postgres\\\"? /d\" \
  | psql -v ON_ERROR_STOP=1
'"

echo "Verifying databases exist..."
ssh "${SSH_USER}@${DB_HOST}" "sudo -n -u postgres psql -c '\l' | egrep -q '${VERIFY_DBS_REGEX}'"

echo "Cleaning up remote files..."
ssh "${SSH_USER}@${DB_HOST}" "rm -f '${REMOTE_UPLOADED}'"
ssh "${SSH_USER}@${DB_HOST}" "sudo -n rm -f '${REMOTE_DUMP}'"
ssh "${SSH_USER}@${DB_HOST}" "sudo -n rmdir '${REMOTE_STAGE_DIR}' 2>/dev/null || true"

echo "OK: restore completed."

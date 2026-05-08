#!/bin/bash
set -euo pipefail

# ── Load env ──────────────────────────────────────────────
source /home/enzo/homeserver/.env

ENZO_UID=1000
ENZO_GID=1000

echo "[+] Creating directory tree..."

dirs=(
  "$DATA_PATH/immich/upload"
  "$DATA_PATH/immich/postgres"
)

for d in "${dirs[@]}"; do
  mkdir -p "$d"
done

ln -s .env immich/.env
ln -s .env traefik/.env

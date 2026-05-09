#!/bin/bash
set -euo pipefail

# ── Load env ──────────────────────────────────────────────
source "/home/$USER/homeserver/.env"

ENZO_UID=1000
ENZO_GID=1000

echo "[+] Creating directory tree..."

dirs=(
  "$DATA_PATH/immich/upload"
  "$DATA_PATH/immich/postgres"
  "$DATA_PATJ/pihole/etc-pihole"
)

for d in "${dirs[@]}"; do
  mkdir -p "$d"
done

ln -s "/home/$USER/homeserver/.env" immich/.env
ln -s "/home/$USER/homeserver/.env" traefik/.env
ln -s "/home/$USER/homeserver/.env" monitoring/.env
ln -s "/home/$USER/homeserver/.env" pihole/.env

# TODO: Install tlp, edit /etc/tlp.conf: 
# START_CHARGE_THRESH_BAT0=75
# STOP_CHARGE_THRESH_BAT0=80
# TLP_DEFAULT_MODE=BAL
# TLP_PERSISTENT_DEFAULT=1
# sudo tlp setcharge 80 1 BAT0


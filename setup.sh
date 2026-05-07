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
  "$DATA_PATH/nextcloud/data"
  "$DATA_PATH/nextcloud/postgres"
  "$DATA_PATH/matrix/synapse"
  "$DATA_PATH/matrix/postgres"
  "$DATA_PATH/filebrowser"
  "$DATA_PATH/jellyfin"
  "$COMMON_PATH/configs/qbittorrent"
  "$COMMON_PATH/configs/sonarr"
  "$COMMON_PATH/configs/radarr"
  "$COMMON_PATH/configs/bazarr"
  "$COMMON_PATH/configs/prowlarr"
  "$COMMON_PATH/configs/jackett"
  "$COMMON_PATH/configs/jellyfin"
  "$COMMON_PATH/configs/jellyseerr"
  "$COMMON_PATH/configs/filebrowser"
  "$COMMON_PATH/qbittorrent/downloads"
  "$COMMON_PATH/sonarr/tv"
  "$COMMON_PATH/radarr/movies"
  "$COMMON_PATH/jellyfin/cache"
  "$PROJECT_DIR/certs"
  "$PROJECT_DIR/traefik/conf.d"
  "$PROJECT_DIR/monitoring"
  "$PROJECT_DIR/homarr/appdata"
)

for d in "${dirs[@]}"; do
  mkdir -p "$d"
done

# ── HDD Mount (/dev/sdb) ──────────────────────────────────
HDD_DEV="/dev/sdb"
if [ -b "$HDD_DEV" ]; then
  HDD_FSTYPE=$(blkid -o value -s TYPE "$HDD_DEV" 2>/dev/null || echo "")

  if [ -z "$HDD_FSTYPE" ]; then
    echo "[!] /dev/sdb has no filesystem. Formatting as ext4..."
    mkfs.ext4 -F -L borgbackup "$HDD_DEV"
    HDD_FSTYPE="ext4"
  fi

  mkdir -p "$HDD_MOUNT"

  HDD_UUID=$(blkid -o value -s UUID "$HDD_DEV")
  if ! grep -q "$HDD_UUID" /etc/fstab; then
    echo "UUID=$HDD_UUID  $HDD_MOUNT  $HDD_FSTYPE  defaults,noatime,nofail  0  2" >> /etc/fstab
    echo "[+] Added HDD to /etc/fstab (UUID=$HDD_UUID)"
  fi

  mountpoint -q "$HDD_MOUNT" || mount "$HDD_MOUNT"
  echo "[+] HDD mounted at $HDD_MOUNT"

  # Create borg directories on HDD
  mkdir -p "$HDD_MOUNT/borg/repo"
  mkdir -p "$HDD_MOUNT/borg/config"
else
  echo "[!] /dev/sdb NOT FOUND. Skipping HDD setup. Creating fallback directories in /mnt/hdd..."
  mkdir -p "$HDD_MOUNT/borg/repo"
  mkdir -p "$HDD_MOUNT/borg/config"
fi

# ── Permissions ──────────────────────────────────────────
chown -R "$ENZO_UID:$ENZO_GID" \
  "$DATA_PATH" \
  "$COMMON_PATH" \
  "$PROJECT_DIR" \
  "$HDD_MOUNT/borg"

echo "[+] Setup complete."

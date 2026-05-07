# Homeserver Podman Stack

## Overview
A complete self-hosted homeserver stack running rootless Podman on Ubuntu. All services are proxied through Traefik with self-signed TLS.

### Architecture
- **Reverse Proxy:** Traefik v3
- **Monitoring:** Prometheus + Grafana + Otel-LGTM
- **Photos:** Immich
- **Cloud:** Nextcloud (Postgres)
- **Media:** Jellyfin + Sonarr + Radarr + Bazarr + Prowlarr + Jackett + Flaresolverr + Qbittorrent + Jellyseerr
- **Communication:** Matrix (Synapse + Postgres)
- **Tools:** LanguageTool + Filebrowser + Homarr + Dashdot
- **Backup:** BorgBackup (on HDD /dev/sdb)
- **Management:** Portainer CE

## Prerequisites
- Ubuntu 22.04+
- Podman 4+ & podman-compose
- Tailscale (for TS FQDN)
- /dev/sdb available for backups

## Quick Start
1. Clone repo: git clone ...
2. Edit .env with secrets.
3. Run sudo bash setup.sh.
4. Deploy stacks: su -l enzo -c "cd homeserver/<stack> && podman-compose --env-file ../.env up -d"

## Service Map
| Service | URL Path | Internal Port |
|---|---|---|
| Jellyfin | /jellyfin | 8096 |
| Sonarr | /sonarr | 8989 |
| Nextcloud | /nextcloud | 80 |
| Immich | /immich | 2283 |
| Portainer | /portainer | 9443 |
| Homarr | /homarr | 7575 |

## Security
- All containers run rootless under the enzo user.
- no-new-privileges: true and cap_drop: ALL (where possible).
- No direct host port exposure except for Traefik (80, 443) and Qbittorrent (6881).
- .env file secured with chmod 600.

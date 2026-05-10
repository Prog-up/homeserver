# homeserver

## Services

- Immich (Google Photo like)
- Pi-hole (Ad Blocker)
- Grafana / Prometheus (Monitoring)
- Traefik (Reverse proxy)

### Reverse proxy ports

- **80:** Immich on local ip only (http)
- **443:** Pi-hole dashboard
- **2283:** Immich on tailscale only (https)
- **3000:** Grafana
- **8080**: Traefik dashboard if enabled
- **9090:** Prometheus

## Tailscale SSL with Traefik

To use Tailscale's automated Let's Encrypt certificates with Traefik:

1. **Generate Certificates**: On the host, run:
   ```bash
   sudo tailscale cert homeserver.tail94e96e.ts.net
   ```
   Move the resulting `.crt` and `.key` files to `./traefik/certs/`.

2. **Traefik Configuration**:
   - Define certificates in a **dynamic configuration file** (`traefik/dynamic_conf.yml`):
     ```yaml
     tls:
       certificates:
         - certFile: /certs/homeserver.tail94e96e.ts.net.crt
           keyFile: /certs/homeserver.tail94e96e.ts.net.key
     ```
   - Enable the file provider in `traefik.yml`:
     ```yaml
     providers:
       file:
         filename: /etc/traefik/dynamic_conf.yml
     ```

3. **Docker Setup**:
   - Mount the `certs` folder and `dynamic_conf.yml` in `compose.yml`.
   - Ensure the `certs` directory has read permissions for the Traefik user (`chmod 755`).

4. **Service Labels**: Enable TLS on your container labels:
   - `traefik.http.routers.my-service.tls=true`

## Network Management

### /etc/network/interfaces
```
allow-hotplug enx00e04c362494
iface enx00e04c362494 inet static
    address 192.168.1.2/24
    gateway 192.168.1.1
```

`sudo systemctl restart networking`

### systemd-resolved

```bash
apt install systemd-resolved
systemctl enable systemd-resolved
ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
vim /etc/systemd/resolved.conf
```

`DNS=8.8.8.8 1.1.1.1`

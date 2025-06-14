# Secure DNS-over-HTTPS (DoH) with Cloudflared + Quad9 on Linux

This project sets up **system-wide encrypted DNS resolution** using [Cloudflare's `cloudflared`](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/installation/) as a DNS-over-HTTPS proxy with **Quad9**'s secure DNS servers.

---

## 🔐 What it does:

- Routes all DNS queries through `cloudflared` (DoH proxy to `https://dns.quad9.net/dns-query`)
- Configures `systemd-resolved` to listen on `127.0.0.1`
- Uses Quad9 as fallback in case `cloudflared` fails
- Runs `cloudflared` as a `systemd` service on port 53
- Prevents leaks via router DNS (e.g., 192.168.1.1)
- Automatically survives reboots

---

## 🧱 Requirements

- Linux system with `systemd` and `systemd-resolved`
- `cloudflared` binary installed (`which cloudflared` must return a path)
- Root access (`sudo`)

---

## ⚙️ Setup Instructions

```bash

# Run the main setup:
sudo bash setup-cloudflared-doh.sh

# If anything breaks, run:
sudo bash reset-dns-to-default.sh

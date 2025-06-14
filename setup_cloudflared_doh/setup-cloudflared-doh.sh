#!/bin/bash

# Exit on any error
set -e

# Check if cloudflared is installed
if ! command -v cloudflared &> /dev/null; then
    echo "❌ cloudflared is not installed. Install it first and re-run this script."
    exit 1
fi

echo "🔧 Configuring systemd-resolved to use cloudflared..."

# Backup and update systemd-resolved config
RESOLVED_CONF="/etc/systemd/resolved.conf"
cp "$RESOLVED_CONF" "$RESOLVED_CONF.bak"

cat <<EOF > "$RESOLVED_CONF"
[Resolve]
DNS=127.0.0.1
FallbackDNS=9.9.9.9 149.112.112.112
DNSStubListener=yes
EOF

# Restart systemd-resolved to apply changes
systemctl restart systemd-resolved
echo "✅ systemd-resolved configured."

# Link systemd-resolved stub to resolv.conf
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
echo "🔗 Linked /etc/resolv.conf to systemd stub."

# Create cloudflared systemd service
CLOUDFLARED_BIN="$(which cloudflared)"
CLOUDFLARED_SERVICE="/etc/systemd/system/cloudflared-dns.service"

cat <<EOF > "$CLOUDFLARED_SERVICE"
[Unit]
Description=cloudflared DoH DNS Proxy (Quad9)
After=network.target

[Service]
ExecStart=$CLOUDFLARED_BIN proxy-dns --port 53 --upstream https://dns.quad9.net/dns-query
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable service
systemctl daemon-reexec
systemctl enable --now cloudflared-dns
echo "🚀 cloudflared DNS service started and enabled on boot."

# Final check
echo "🔍 Final DNS status:"
resolvectl status | grep "DNS Server"

echo -e "\n✅ Setup complete. Your system is now using Quad9 DNS-over-HTTPS via cloudflared."

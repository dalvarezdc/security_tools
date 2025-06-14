
---

## 🧯 Recovery Script: `reset-dns-to-default.sh`

```bash
#!/bin/bash

# Stop the cloudflared DNS service if it exists
echo "🛑 Stopping cloudflared service (if running)..."
systemctl stop cloudflared-dns || true
systemctl disable cloudflared-dns || true

# Remove custom systemd service if it exists
if [ -f /etc/systemd/system/cloudflared-dns.service ]; then
    rm /etc/systemd/system/cloudflared-dns.service
    echo "🗑️ Removed cloudflared-dns systemd service."
fi

# Restore systemd-resolved to default settings
echo "♻️ Resetting /etc/systemd/resolved.conf..."
cp /etc/systemd/resolved.conf.bak /etc/systemd/resolved.conf || {
    echo "⚠️ No backup found. Manual fix might be needed."
}

# Restore resolv.conf to use NetworkManager or original settings
echo "🔗 Resetting /etc/resolv.conf to system default..."
rm -f /etc/resolv.conf
ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

# Restart systemd-resolved
echo "🔄 Restarting systemd-resolved..."
systemctl daemon-reexec
systemctl restart systemd-resolved

# Final status
echo -e "\n✅ DNS reset complete."
resolvectl status | grep "DNS Server"

# 1. Download latest .deb package
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb

# 2. Install it
sudo dpkg -i cloudflared-linux-amd64.deb

# 3. Test it works
cloudflared --version

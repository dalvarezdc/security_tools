# 🔒 Security Tools Collection

A professional collection of security-related tools and scripts designed for defensive security analysis, network monitoring, and privacy protection. Built with modern Python practices and comprehensive error handling.

## Table of Contents

- [🚀 Features](#-features)
- [📋 Requirements](#-requirements)
- [⚡ Installation](#-installation)
- [🎯 Usage](#-usage)
- [🛠️ Available Tools](#️-available-tools)
- [⚙️ Configuration](#️-configuration)
- [🧪 Testing](#-testing)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

## 🚀 Features

- **VPN Leak Detector**: Monitor VPN connections for IP and DNS leaks
- **Port Scanner**: Parallel port scanning with service identification
- **IP Sweeper**: Network discovery and host enumeration
- **EXIF Reader/Remover**: Extract or remove metadata from images and PDFs
- **VPN Killswitch**: Firewall-based VPN kill switch for Linux
- **Network Configuration**: Automated network interface discovery
- **Centralized Configuration**: Environment-based configuration management
- **Professional Logging**: Structured logging with multiple levels
- **Comprehensive Testing**: Unit tests and security scanning

## 📋 Requirements

- **Python**: 3.8 or higher
- **Operating System**: Linux, macOS, or WSL on Windows
- **System Tools**: `curl`, `ping`, `iptables` (for VPN tools), `ip` command
- **Privileges**: Some tools require root/sudo access for network operations

## ⚡ Installation

### Quick Start
```bash
# Clone the repository
git clone https://github.com/dalvarezdc/security_tools.git
cd security_tools

# Install UV (fast Python package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Run automated setup
python3 setup.py
```

### Manual Installation
```bash
# Install dependencies with UV
uv pip install -r requirements.txt

# Or install with development tools
uv pip install -e .[dev]

# Make scripts executable
chmod +x **/*.sh

# Copy configuration template
cp .env.example .env
```

## 🎯 Usage

### Interactive Menu
```bash
python3 main.py
```

### Individual Tools
```bash
# VPN leak detection
python3 vpn_leak_detector/detect_leaks.py

# Port scanning
./port_scanner/portscanner.sh 192.168.1.1 1 1000

# Network discovery
./ipsweeper/ipsweeper.sh 192.168.1

# EXIF data handling
python3 exif_reader/exif_reader.py /path/to/images --remove
```

## 🛠️ Available Tools

### 1. VPN Leak Detector (`vpn_leak_detector/`)
Monitor your VPN connection for IP and DNS leaks in real-time.
```bash
# Set your VPN server IP
export VPN_SERVER_IP="your.vpn.server.ip"
python3 vpn_leak_detector/detect_leaks.py
```

### 2. Port Scanner (`port_scanner/`)
High-performance parallel port scanner with service identification.
```bash
./port_scanner/portscanner.sh <TARGET_IP> <START_PORT> <END_PORT> [open|closed]
# Example: ./port_scanner/portscanner.sh 192.168.1.1 1 1000 open
```

### 3. IP Sweeper (`ipsweeper/`)
Discover active hosts in a network range using ping.
```bash
./ipsweeper/ipsweeper.sh <NETWORK_RANGE>
# Example: ./ipsweeper/ipsweeper.sh 192.168.1
```

### 4. EXIF Reader/Remover (`exif_reader/`)
Extract or remove metadata from images and PDF files.
```bash
# View metadata
python3 exif_reader/exif_reader.py /path/to/files

# Remove metadata
python3 exif_reader/exif_reader.py /path/to/files --remove
```

### 5. VPN Killswitch (`vpn_killswitch/`)
Firewall-based kill switch to prevent traffic leaks if VPN disconnects.
```bash
# Setup killswitch (requires root)
sudo ./vpn_killswitch/openvpn_killswitch.sh start

# Remove killswitch
sudo ./vpn_killswitch/openvpn_killswitch.sh stop

# Check VPN status
./vpn_killswitch/openvpn_killswitch.sh status
```

### 6. Network Configuration Tools
- **Find Network Variables**: `./vpn_killswitch/find_network_vars.sh`
- **OpenVPN Starter**: `./open_vpn_tools/start_vpn.sh`
- **IP Details**: `./vpn_leak_detector/get_ip_details.sh`

### 7. Security Package Installer (`debian_safety_packages/`)
Install essential security packages on Debian/Ubuntu systems.
```bash
./debian_safety_packages/install_packages.sh
```

## ⚙️ Configuration

### Environment Variables
Create a `.env` file from the template:
```bash
cp .env.example .env
```

Key configuration options:
```bash
# VPN Configuration
VPN_SERVER_IP=your.vpn.server.ip.here

# Network Settings
INTERNET_IF=eth0
VPN_IF=tun0
LOCAL_NET=192.168.1.0/24

# Logging
LOG_LEVEL=INFO
```

### Configuration File
The tools use `config.py` for centralized configuration management, supporting both environment variables and JSON configuration files.

## 🧪 Testing

Run the test suite:
```bash
# Install test dependencies
uv pip install -e .[test]

# Run tests
python3 -m pytest tests/ -v

# Run with coverage
python3 -m pytest tests/ --cov=. --cov-report=html
```

Security scanning:
```bash
# Install security tools
uv pip install -e .[security]

# Run security audit
bandit -r . -f json -o security_report.json
safety check
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-tool`
3. Make your changes and add tests
4. Run security checks: `bandit -r .`
5. Submit a pull request

### Development Setup
```bash
# Install development dependencies
uv pip install -e .[dev]

# Install pre-commit hooks
pre-commit install

# Run linting
black .
flake8 .
mypy .
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

These tools are designed for **defensive security purposes only**. Use responsibly and only on systems you own or have explicit permission to test. The authors are not responsible for any misuse of these tools.

## 🔗 Useful Resources

- [UV Package Manager](https://github.com/astral-sh/uv)
- [Python Security Best Practices](https://python.org/dev/security/)
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)


#!/usr/bin/env python3
"""
Setup script for Security Tools repository.
Installs dependencies and configures the environment.
"""

import os
import sys
import subprocess
import shutil
from pathlib import Path

def run_command(command, check=True):
    """Run shell command safely."""
    try:
        result = subprocess.run(
            command, 
            shell=True, 
            check=check, 
            capture_output=True, 
            text=True
        )
        return result.returncode == 0, result.stdout, result.stderr
    except subprocess.CalledProcessError as e:
        return False, e.stdout, e.stderr

def check_python_version():
    """Check if Python version is adequate."""
    if sys.version_info < (3, 7):
        print("❌ Python 3.7 or higher is required")
        return False
    print(f"✅ Python {sys.version_info.major}.{sys.version_info.minor} detected")
    return True

def install_python_dependencies():
    """Install Python dependencies using UV."""
    print("\n📦 Installing Python dependencies with UV...")
    
    success, stdout, stderr = run_command("uv pip install -r requirements.txt")
    if success:
        print("✅ Python dependencies installed successfully")
        return True
    else:
        print(f"❌ Failed to install Python dependencies: {stderr}")
        return False

def check_system_dependencies():
    """Check for required system tools."""
    print("\n🔧 Checking system dependencies...")
    
    required_tools = ['curl', 'ping', 'iptables', 'ip']
    missing_tools = []
    
    for tool in required_tools:
        if not shutil.which(tool):
            missing_tools.append(tool)
        else:
            print(f"✅ {tool} found")
    
    if missing_tools:
        print(f"❌ Missing required tools: {', '.join(missing_tools)}")
        print("Please install them using your package manager:")
        print("  Ubuntu/Debian: sudo apt install curl iputils-ping iptables iproute2")
        print("  CentOS/RHEL: sudo yum install curl iputils iptables iproute")
        print("  macOS: These tools should be available by default")
        return False
    
    return True

def setup_configuration():
    """Set up configuration files."""
    print("\n⚙️ Setting up configuration...")
    
    # Copy example config if .env doesn't exist
    if not os.path.exists('.env'):
        if os.path.exists('.env.example'):
            shutil.copy('.env.example', '.env')
            print("✅ Created .env file from template")
            print("⚠️  Please edit .env file with your specific configuration")
        else:
            print("⚠️  .env.example not found, creating basic .env")
            with open('.env', 'w') as f:
                f.write("# Security Tools Configuration\n")
                f.write("VPN_SERVER_IP=your.vpn.server.ip.here\n")
                f.write("LOG_LEVEL=INFO\n")
    else:
        print("✅ .env file already exists")
    
    # Create logs directory
    os.makedirs('logs', exist_ok=True)
    print("✅ Created logs directory")
    
    return True

def make_scripts_executable():
    """Make shell scripts executable."""
    print("\n🔐 Making shell scripts executable...")
    
    script_paths = [
        'ipsweeper/ipsweeper.sh',
        'port_scanner/portscanner.sh',
        'vpn_killswitch/openvpn_killswitch.sh',
        'vpn_killswitch/find_network_vars.sh',
        'vpn_leak_detector/get_ip_details.sh',
        'open_vpn_tools/start_vpn.sh',
        'open_vpn_tools/select_interface.sh',
        'debian_safety_packages/install_packages.sh'
    ]
    
    for script_path in script_paths:
        if os.path.exists(script_path):
            os.chmod(script_path, 0o755)
            print(f"✅ Made {script_path} executable")
    
    return True

def main():
    """Main setup function."""
    print("🔒 Security Tools Setup")
    print("=" * 50)
    
    success = True
    
    # Check Python version
    if not check_python_version():
        success = False
    
    # Install Python dependencies
    if success and not install_python_dependencies():
        success = False
    
    # Check system dependencies
    if success and not check_system_dependencies():
        success = False
    
    # Setup configuration
    if success and not setup_configuration():
        success = False
    
    # Make scripts executable
    if success and not make_scripts_executable():
        success = False
    
    print("\n" + "=" * 50)
    if success:
        print("✅ Setup completed successfully!")
        print("\nNext steps:")
        print("1. Edit .env file with your configuration")
        print("2. Test tools individually")
        print("3. Run: python3 main.py for the main menu")
    else:
        print("❌ Setup encountered errors. Please resolve them and run again.")
        sys.exit(1)

if __name__ == "__main__":
    main()
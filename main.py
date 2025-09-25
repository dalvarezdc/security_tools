#!/usr/bin/env python3
"""
Security Tools - Main Menu Interface
A collection of security-related tools and scripts.
"""

import os
import sys
import subprocess
from pathlib import Path

from config import config
from utils import logger

class SecurityToolsMenu:
    """Main menu interface for security tools."""
    
    def __init__(self):
        self.tools = {
            '1': {
                'name': 'VPN Leak Detector',
                'description': 'Monitor VPN for IP and DNS leaks',
                'script': 'vpn_leak_detector/detect_leaks.py'
            },
            '2': {
                'name': 'Port Scanner',
                'description': 'Scan for open ports on target systems',
                'script': 'port_scanner/portscanner.sh'
            },
            '3': {
                'name': 'IP Sweeper',
                'description': 'Discover active hosts in network range',
                'script': 'ipsweeper/ipsweeper.sh'
            },
            '4': {
                'name': 'EXIF Reader/Remover',
                'description': 'View or remove metadata from images and PDFs',
                'script': 'exif_reader/exif_reader.py'
            },
            '5': {
                'name': 'VPN Killswitch',
                'description': 'Configure firewall rules for VPN security',
                'script': 'vpn_killswitch/openvpn_killswitch.sh'
            },
            '6': {
                'name': 'Get IP Details',
                'description': 'Get detailed information about your public IP',
                'script': 'vpn_leak_detector/get_ip_details.sh'
            },
            '7': {
                'name': 'Install Security Packages',
                'description': 'Install essential security packages (Debian/Ubuntu)',
                'script': 'debian_safety_packages/install_packages.sh'
            },
            '8': {
                'name': 'Find Network Variables',
                'description': 'Discover network configuration for VPN setup',
                'script': 'vpn_killswitch/find_network_vars.sh'
            }
        }
    
    def display_menu(self):
        """Display the main menu."""
        print("\n" + "="*60)
        print("🔒 SECURITY TOOLS COLLECTION")
        print("="*60)
        print("Select a tool to run:")
        print()
        
        for key, tool in self.tools.items():
            print(f"  {key}. {tool['name']}")
            print(f"     {tool['description']}")
            print()
        
        print("  0. Exit")
        print("="*60)
    
    def validate_script_exists(self, script_path):
        """Check if script file exists."""
        if not os.path.exists(script_path):
            logger.error(f"Script not found: {script_path}")
            return False
        return True
    
    def run_python_script(self, script_path):
        """Run a Python script."""
        try:
            subprocess.run([sys.executable, script_path], check=True)
        except subprocess.CalledProcessError as e:
            logger.error(f"Failed to run {script_path}: {e}")
        except KeyboardInterrupt:
            logger.info("Script interrupted by user")
    
    def run_shell_script(self, script_path):
        """Run a shell script."""
        try:
            subprocess.run(['bash', script_path], check=True)
        except subprocess.CalledProcessError as e:
            logger.error(f"Failed to run {script_path}: {e}")
        except KeyboardInterrupt:
            logger.info("Script interrupted by user")
    
    def run_tool(self, choice):
        """Run the selected tool."""
        if choice not in self.tools:
            print("Invalid choice. Please try again.")
            return
        
        tool = self.tools[choice]
        script_path = tool['script']
        
        if not self.validate_script_exists(script_path):
            return
        
        print(f"\n🚀 Running: {tool['name']}")
        print("-" * 50)
        
        # Determine script type and run accordingly
        if script_path.endswith('.py'):
            self.run_python_script(script_path)
        elif script_path.endswith('.sh'):
            self.run_shell_script(script_path)
        else:
            logger.error(f"Unknown script type: {script_path}")
    
    def run(self):
        """Main menu loop."""
        logger.info("Security Tools Collection started")
        
        while True:
            try:
                self.display_menu()
                choice = input("Enter your choice (0-8): ").strip()
                
                if choice == '0':
                    print("\n👋 Goodbye!")
                    break
                elif choice in self.tools:
                    self.run_tool(choice)
                    input("\nPress Enter to continue...")
                else:
                    print("❌ Invalid choice. Please enter a number between 0-8.")
                    
            except KeyboardInterrupt:
                print("\n\n👋 Goodbye!")
                break
            except Exception as e:
                logger.error(f"Unexpected error: {e}")
                print("❌ An unexpected error occurred. Check logs for details.")

def main():
    """Main entry point."""
    try:
        menu = SecurityToolsMenu()
        menu.run()
    except Exception as e:
        logger.error(f"Failed to start application: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()

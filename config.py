"""
Configuration management module for security tools.
Centralizes configuration loading from environment variables and files.
"""

import os
import json
import logging
from pathlib import Path
from typing import Dict, Any, Optional

class Config:
    """Centralized configuration management."""
    
    def __init__(self, config_file: Optional[str] = None):
        self.config_file = config_file or os.path.join(os.path.dirname(__file__), 'config.json')
        self.config_data = {}
        self.load_config()
    
    def load_config(self) -> None:
        """Load configuration from file and environment variables."""
        # Load from JSON file if exists
        if os.path.exists(self.config_file):
            try:
                with open(self.config_file, 'r') as f:
                    self.config_data = json.load(f)
            except (json.JSONDecodeError, IOError) as e:
                logging.warning(f"Failed to load config file {self.config_file}: {e}")
        
        # Override with environment variables
        self._load_env_vars()
    
    def _load_env_vars(self) -> None:
        """Load configuration from environment variables."""
        env_mappings = {
            'VPN_SERVER_IP': 'vpn.server_ip',
            'INTERNET_IF': 'network.internet_interface',
            'VPN_IF': 'network.vpn_interface',
            'LOCAL_NET': 'network.local_network',
            'LOG_LEVEL': 'logging.level',
            'API_TIMEOUT': 'api.timeout'
        }
        
        for env_var, config_key in env_mappings.items():
            if env_value := os.getenv(env_var):
                self._set_nested_value(config_key, env_value)
    
    def _set_nested_value(self, key: str, value: str) -> None:
        """Set nested configuration value using dot notation."""
        keys = key.split('.')
        current = self.config_data
        
        for k in keys[:-1]:
            current = current.setdefault(k, {})
        
        current[keys[-1]] = value
    
    def get(self, key: str, default: Any = None) -> Any:
        """Get configuration value using dot notation."""
        keys = key.split('.')
        current = self.config_data
        
        try:
            for k in keys:
                current = current[k]
            return current
        except (KeyError, TypeError):
            return default
    
    def get_vpn_config(self) -> Dict[str, str]:
        """Get VPN-related configuration."""
        return {
            'server_ip': self.get('vpn.server_ip', 'YOUR_VPN_SERVER_IP'),
            'interface': self.get('network.vpn_interface', 'tun0'),
            'timeout': int(self.get('api.timeout', '30'))
        }
    
    def get_network_config(self) -> Dict[str, str]:
        """Get network-related configuration."""
        return {
            'internet_interface': self.get('network.internet_interface', 'eth0'),
            'vpn_interface': self.get('network.vpn_interface', 'tun0'),
            'local_network': self.get('network.local_network', '192.168.1.0/24')
        }

# Global config instance
config = Config()
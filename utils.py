"""
Utility functions for security tools.
Common functionality shared across multiple tools.
"""

import re
import os
import sys
import logging
import requests
from typing import Optional, Dict, Any
from pathlib import Path

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout),
        logging.FileHandler('security_tools.log')
    ]
)

logger = logging.getLogger(__name__)

class ValidationError(Exception):
    """Custom exception for validation errors."""
    pass

def validate_ip_address(ip: str) -> bool:
    """Validate IPv4 address format."""
    pattern = r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'
    return bool(re.match(pattern, ip))

def validate_network_range(network: str) -> bool:
    """Validate network range format (e.g., 192.168.1)."""
    pattern = r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){2}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'
    return bool(re.match(pattern, network))

def validate_port_range(start_port: int, end_port: int) -> bool:
    """Validate port range."""
    return (1 <= start_port <= 65535 and 
            1 <= end_port <= 65535 and 
            start_port <= end_port)

def sanitize_filename(filename: str) -> str:
    """Sanitize filename to prevent path traversal attacks."""
    # Remove path separators and dangerous characters
    sanitized = re.sub(r'[<>:"/\\|?*]', '_', filename)
    sanitized = re.sub(r'\.\.+', '_', sanitized)  # Remove multiple dots
    return sanitized[:255]  # Limit filename length

def get_public_ip(timeout: int = 10) -> Optional[str]:
    """
    Get public IP address from external service.
    
    Args:
        timeout: Request timeout in seconds
        
    Returns:
        Public IP address or None if failed
    """
    services = [
        'https://api.ipify.org',
        'https://ipinfo.io/ip',
        'https://httpbin.org/ip'
    ]
    
    for service in services:
        try:
            response = requests.get(
                service, 
                timeout=timeout,
                headers={'User-Agent': 'SecurityTools/1.0'}
            )
            response.raise_for_status()
            
            # Handle different response formats
            if 'ipify' in service:
                return response.text.strip()
            elif 'ipinfo' in service:
                return response.text.strip()
            elif 'httpbin' in service:
                import json
                return json.loads(response.text)['origin']
                
        except (requests.RequestException, ValueError, KeyError) as e:
            logger.warning(f"Failed to get IP from {service}: {e}")
            continue
    
    logger.error("Failed to get public IP from all services")
    return None

def get_ip_details(ip: Optional[str] = None, timeout: int = 10) -> Dict[str, Any]:
    """
    Get detailed IP information.
    
    Args:
        ip: IP address to lookup (defaults to public IP)
        timeout: Request timeout in seconds
        
    Returns:
        Dictionary with IP details
    """
    if not ip:
        ip = get_public_ip(timeout)
        if not ip:
            return {}
    
    try:
        response = requests.get(
            f'https://ipinfo.io/{ip}/json',
            timeout=timeout,
            headers={'User-Agent': 'SecurityTools/1.0'}
        )
        response.raise_for_status()
        return response.json()
        
    except (requests.RequestException, ValueError) as e:
        logger.error(f"Failed to get IP details for {ip}: {e}")
        return {}

def check_root_privileges() -> bool:
    """Check if script is running with root privileges."""
    return os.geteuid() == 0

def ensure_directory(path: str) -> None:
    """Ensure directory exists, create if it doesn't."""
    Path(path).mkdir(parents=True, exist_ok=True)

def safe_file_write(filepath: str, content: str, mode: str = 'w') -> bool:
    """
    Safely write content to file with proper error handling.
    
    Args:
        filepath: Path to file
        content: Content to write
        mode: File open mode
        
    Returns:
        True if successful, False otherwise
    """
    try:
        # Ensure directory exists
        ensure_directory(os.path.dirname(filepath))
        
        # Sanitize filename
        filename = os.path.basename(filepath)
        directory = os.path.dirname(filepath)
        safe_filename = sanitize_filename(filename)
        safe_filepath = os.path.join(directory, safe_filename)
        
        with open(safe_filepath, mode) as f:
            f.write(content)
        
        logger.info(f"Successfully wrote to {safe_filepath}")
        return True
        
    except IOError as e:
        logger.error(f"Failed to write to {filepath}: {e}")
        return False
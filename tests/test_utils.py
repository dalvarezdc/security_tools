#!/usr/bin/env python3
"""
Unit tests for utils module.
"""

import unittest
import tempfile
import os
import sys
from unittest.mock import patch, Mock

# Add parent directory to path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from utils import (
    validate_ip_address, validate_network_range, validate_port_range,
    sanitize_filename, get_public_ip, safe_file_write
)

class TestUtils(unittest.TestCase):
    """Test cases for utility functions."""
    
    def test_validate_ip_address(self):
        """Test IP address validation."""
        # Valid IPs
        self.assertTrue(validate_ip_address("192.168.1.1"))
        self.assertTrue(validate_ip_address("8.8.8.8"))
        self.assertTrue(validate_ip_address("127.0.0.1"))
        self.assertTrue(validate_ip_address("255.255.255.255"))
        
        # Invalid IPs
        self.assertFalse(validate_ip_address("256.1.1.1"))
        self.assertFalse(validate_ip_address("192.168.1"))
        self.assertFalse(validate_ip_address("192.168.1.1.1"))
        self.assertFalse(validate_ip_address("not.an.ip.address"))
        self.assertFalse(validate_ip_address(""))
    
    def test_validate_network_range(self):
        """Test network range validation."""
        # Valid ranges
        self.assertTrue(validate_network_range("192.168.1"))
        self.assertTrue(validate_network_range("10.0.0"))
        self.assertTrue(validate_network_range("172.16.0"))
        
        # Invalid ranges
        self.assertFalse(validate_network_range("256.1.1"))
        self.assertFalse(validate_network_range("192.168"))
        self.assertFalse(validate_network_range("192.168.1.1"))
        self.assertFalse(validate_network_range(""))
    
    def test_validate_port_range(self):
        """Test port range validation."""
        # Valid ranges
        self.assertTrue(validate_port_range(1, 65535))
        self.assertTrue(validate_port_range(80, 443))
        self.assertTrue(validate_port_range(1000, 1000))
        
        # Invalid ranges
        self.assertFalse(validate_port_range(0, 100))
        self.assertFalse(validate_port_range(100, 65536))
        self.assertFalse(validate_port_range(200, 100))
        self.assertFalse(validate_port_range(-1, 100))
    
    def test_sanitize_filename(self):
        """Test filename sanitization."""
        # Valid filename
        self.assertEqual(sanitize_filename("test.txt"), "test.txt")
        
        # Dangerous characters
        self.assertEqual(sanitize_filename("test<>:\"/|?*.txt"), "test_________.txt")
        
        # Path traversal attempts
        self.assertEqual(sanitize_filename("../../../etc/passwd"), "_etc_passwd")
        self.assertEqual(sanitize_filename("....txt"), "_.txt")
        
        # Long filename
        long_name = "a" * 300
        sanitized = sanitize_filename(long_name)
        self.assertLessEqual(len(sanitized), 255)
    
    @patch('utils.requests.get')
    def test_get_public_ip_success(self, mock_get):
        """Test successful public IP retrieval."""
        mock_response = Mock()
        mock_response.text = "8.8.8.8"
        mock_response.raise_for_status.return_value = None
        mock_get.return_value = mock_response
        
        result = get_public_ip()
        self.assertEqual(result, "8.8.8.8")
    
    @patch('utils.requests.get')
    def test_get_public_ip_failure(self, mock_get):
        """Test failed public IP retrieval."""
        mock_get.side_effect = Exception("Network error")
        
        result = get_public_ip()
        self.assertIsNone(result)
    
    def test_safe_file_write(self):
        """Test safe file writing."""
        with tempfile.TemporaryDirectory() as temp_dir:
            file_path = os.path.join(temp_dir, "test.txt")
            content = "Hello, World!"
            
            # Test successful write
            result = safe_file_write(file_path, content)
            self.assertTrue(result)
            
            # Verify file content
            with open(file_path, 'r') as f:
                self.assertEqual(f.read(), content)
            
            # Test with dangerous filename
            dangerous_path = os.path.join(temp_dir, "../../../etc/passwd")
            result = safe_file_write(dangerous_path, content)
            self.assertTrue(result)  # Should succeed but with sanitized name

if __name__ == '__main__':
    unittest.main()
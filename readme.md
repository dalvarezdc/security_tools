# Security Tools Repository

This repository contains a collection of security-related tools and scripts designed to enhance and ensure computer security. The tools span a range of categories, from network scanning to encryption, ensuring a comprehensive approach to security.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Contribution](#contribution)
- [License](#license)

## Features

- **Password Strength Checker**: Validates the strength of passwords.
- **Port Scanner**: Identifies open ports on a system.
- **Encryption/Decryption Tools**: Ensures data protection through encryption.
- **File Integrity Checker**: Verifies file integrity using cryptographic hashing.
- **Log Analyzer**: Detects suspicious activities from logs.
- **... and many more!**

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/dalvarezdc/security_tools.git
   ```
2. Navigate to the directory:
   ```bash
   cd security_tools
   ```
3. Find all files and apply chmod +x, printing each file whose permissions are changed
   ```commandline
   find . -type f -exec chmod +x {} \; -exec echo "Permissions changed for file: {}" \;
   ```

## Modules

Modules or tools to consider adding to "security tools" repository:

1. **Password Strength Checker**:
   - A tool to validate the strength of passwords, checking for length, use of special characters, numbers, upper/lowercase letters, and common password patterns.

2. **Port Scanner**:
   - Quickly scan for open ports on a system to determine potential vulnerabilities.

3. **Encryption/Decryption Tools**:
   - Implementing simple symmetric and asymmetric encryption algorithms for data protection.

4. **File Integrity Checker**:
   - Use cryptographic hashing (like SHA-256) to verify the integrity of files over time or after transfers.

5. **Log Analyzer**:
   - Parse and analyze system or application logs to detect suspicious activities.

6. **Steganography Tools**:
   - Hide messages inside images or other files and extract them.

7. **Metadata Extractor**:
   - Extract metadata from files (especially images) to see what information they might be inadvertently sharing.

8. **Network Packet Sniffer**:
   - Capture and analyze network packets to detect unusual traffic patterns or potential breaches.

9. **Phishing Domain Detector**:
   - Check if a domain name is suspiciously similar to popular domains, which might indicate it's being used for phishing.

10. **Basic Web Vulnerability Scanner**:
   - Automate the process of checking for common web vulnerabilities like SQL injection, XSS, CSRF, etc.

11. **Brute Force Protection**:
   - A tool that monitors login attempts and applies restrictions or additional checks if too many failures are detected.

12. **Public WiFi Safety Tools**:
   - Features like VPN initiation reminders or checks for ARP spoofing when connected to public networks.

13. **Two-Factor Authentication Implementation**:
   - A module to demonstrate how TOTP or other 2FA methods work.

14. **Rate Limiter**:
   - Limit the number of requests a client can make in a time window to protect against DoS attacks.

15. **CAPTCHA Implementation**:
   - Implement a basic CAPTCHA to protect against bots.

16. **Data Leak Checker**:
   - Input an email or username and check against known data breach databases to see if it has been compromised.

17. **Secure File Deletion**:
   - Tools to securely delete files by overwriting them multiple times.


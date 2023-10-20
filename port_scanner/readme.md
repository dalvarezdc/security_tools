# Security Tools - Port Scanner

This port scanner is a simple yet powerful tool written in Bash to help you identify open and closed ports on a target system. The script uses parallel scanning for increased speed and provides the option to focus on open, closed, or both types of ports. The results are conveniently saved as a CSV file.

## Features
- Scan for open, closed, or both types of ports
- Parallel scanning for faster results
- Results saved as CSV
- Provides common port descriptions

## Prerequisites
- Bash environment
- `xargs` utility (usually comes preinstalled on Unix-like systems)

## Usage
```bash
./portscanner.sh <TARGET_IP> <START_PORT> <END_PORT> [OPTION]
```

**Arguments**:
- `TARGET_IP`: IP address of the target system
- `START_PORT`: Starting port for the scan range
- `END_PORT`: Ending port for the scan range
- `OPTION`: (Optional) Specify as `open` for scanning open ports, `closed` for closed ports. Leave blank to scan for both.

**Example**:
```bash
./portscanner.sh 192.168.1.1 1 1000 open
```

This will scan the IP `192.168.1.1` from port `1` to `1000` for open ports.

## Common Ports and Their Meanings
- `21`: FTP
- `22`: SSH
- `23`: Telnet
- `25`: SMTP
- `53`: DNS
- `80`: HTTP
- `110`: POP3
- `143`: IMAP
- `443`: HTTPS
- `465`: SMTPS

... [and so on for other ports in your script]

## Contributing
Feel free to fork this repository and submit pull requests. All contributions are welcome!


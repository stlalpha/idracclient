# iDRAC KVM Client

Dell iDRAC client launcher for Linux, macOS and Windows. Compatible with Dell iDRAC 6/7/8.

Downloads needed Java files and sets up port forwarding via SSH for remote access to server consoles.

**Note:** This is a fork/update of the original script by Jonas Jelten, modified for compatibility with modern Python (3.10+) and Java (9+) versions.

## Features

- Automatic download of iDRAC KVM Java files
- SSH port forwarding for remote access via jumphost
- SSL/TLS configuration for older iDRAC crypto
- Native library support for enhanced keyboard/mouse input

## Requirements

- Python 3.6 or later
- Java Runtime Environment (Java 8/JRE 1.8 recommended, but works with newer versions)
- SSH client (for jumphost functionality)
- `aiohttp` Python library

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/idracclient.git
   cd idracclient
   ```

2. Create a virtual environment and install dependencies:
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\activate
   pip install aiohttp
   ```

## Usage

### Direct connection:
```bash
./idracclient.py your-idrac-hostname
```

### With custom username and port:
```bash
./idracclient.py --username administrator --port 5900 192.168.0.132
```

### Through SSH jumphost:
```bash
./idracclient.py -J jumphost.example.com your-idrac-hostname
```

### Common options:
- `-u, --username` - iDRAC username (default: root)
- `-p, --port` - HTTPS port (default: 443)
- `-k, --kvmport` - KVM connection port (default: 5900)
- `-J, --jumphost` - SSH jumphost for port forwarding
- `-f, --force-download` - Re-download KVM viewer files
- `--no-native-libs` - Skip native library downloads
- `--java` - Custom Java executable path
- `--dryrun` - Test without launching viewer

## Java Compatibility

The script was originally designed for Java 8, but has been updated to work with modern Java versions (tested with Java 25).

If you experience issues with newer Java versions, you can:
1. Install Java 8 and specify it: `--java /path/to/java8`
2. Skip native libraries: `--no-native-libs`

## Examples

```bash
# Basic connection
./idracclient.py 192.168.0.132

# With specific username and port
./idracclient.py -u administrator -p 5900 192.168.0.132

# Through jumphost
./idracclient.py -J jumphost.internal.com server-idrac.internal.com

# Force re-download files
./idracclient.py -f 192.168.0.132
```

## License

Original work (c) 2018-2019 Jonas Jelten <jelten@in.tum.de>

Released under GNU GPLv3 or any later version

## Credits

- **Original Author:** Jonas Jelten <jelten@in.tum.de>
- This repository contains modernization updates for Python 3.10+ and Java 9+ compatibility

## Updates in This Fork

- Fixed compatibility with Python 3.10+ (replaced deprecated `asyncio.get_event_loop()`)
- Added `--enable-native-access` flag for Java 9+ compatibility
- Updated documentation with comprehensive usage examples

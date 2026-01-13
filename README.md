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

### Quick Install (Recommended)

One-line installation via curl:
```bash
curl -sSL https://raw.githubusercontent.com/stlalpha/idracclient/master/install.sh | bash
```

This will:
- Download the script to `~/.local/bin/idracclient`
- Install Python dependencies (aiohttp)
- Check for Python and Java
- Add to your PATH (if needed)

### Manual Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/stlalpha/idracclient.git
   cd idracclient
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   # or
   pip install aiohttp
   ```

3. Make executable:
   ```bash
   chmod +x idracclient.py
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

⚠️ **IMPORTANT: Java 8 is strongly recommended for full functionality**

The script was originally designed for Java 8. While it has been updated to launch with modern Java versions (tested with Java 25), **keyboard input may not work properly with Java 9+** due to Swing/AWT compatibility issues.

### Known Issues with Java 9+:
- ✅ **Mouse input**: Works correctly
- ❌ **Keyboard input**: May not function (confirmed issue on Java 20+)
- ⚠️ **Native libraries**: Require `--enable-native-access` flag

### Recommended Setup:

**Option 1: Use Java 8 (Best compatibility)**

Install Java 8 for your operating system:
- **Linux**: Use your package manager (apt, yum, pacman, etc.) to install `openjdk-8-jre` or similar
- **macOS**: `brew install openjdk@8` or download from [Adoptium](https://adoptium.net/)
- **Windows**: Download from [Adoptium](https://adoptium.net/) or [Oracle](https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html)
- **Any OS**: [Liberica JDK 8 FX](https://bell-sw.com/pages/downloads/#jdk-8-lts) (includes JavaFX)

Then run with Java 8:
```bash
# Linux/macOS
./idracclient.py --java /path/to/java8/bin/java 192.168.0.132

# Windows
python idracclient.py --java "C:\Path\To\Java8\bin\java.exe" 192.168.0.132
```

**Option 2: Use newer Java (Mouse only, limited keyboard)**
```bash
# Works for viewing, but keyboard may not function
./idracclient.py 192.168.0.132
```

**Option 3: Skip native libraries**
```bash
# Limited functionality, but fewer compatibility issues
./idracclient.py --no-native-libs 192.168.0.132
```

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

## Troubleshooting

### Connection Issues

**"No route to host" (Error 113)**
- Verify the iDRAC IP address is correct
- Check network connectivity: `ping <idrac-ip>`
- Ensure you're on the same network or use a jumphost
- Try the web interface first: `https://<idrac-ip>`

**SSL/TLS Errors**
- Use `--tlscheck` flag to enable certificate validation (disabled by default)
- Older iDRACs use outdated crypto - the script handles this automatically

**Connection Timeout**
- Check if port 443 (HTTPS) and 5900 (KVM) are open
- Use custom ports if needed: `--port 443 --kvmport 5900`
- Try connecting through a jumphost: `-J jumphost.example.com`

### Java Issues

**Keyboard Not Working**
- **Solution:** Use Java 8 instead of newer versions
- Install Java 8 and specify it: `--java /path/to/java8/bin/java`
- See Java Compatibility section above for installation instructions

**"UnsatisfiedLinkError" with Native Libraries**
- **Modern Java (9+):** Script automatically adds `--enable-native-access` flag
- **Alternative:** Skip native libs: `--no-native-libs` (reduced functionality)

**Java Not Found**
- Install Java: See Requirements section
- Specify Java path: `--java /path/to/java`
- Check Java installation: `java -version`

### Download Issues

**Files Won't Download**
- Force re-download: `--force-download` or `-f`
- Check iDRAC web interface is accessible
- Ensure iDRAC firmware is up to date

### Jumphost/SSH Issues

**Port Forwarding Timeout**
- Increase SSH timeout: `--sshtimeout 30` (default: 8 seconds)
- Verify SSH access to jumphost works manually
- Check SSH keys or password authentication

**Custom Ports**
- Specify local ports: `--jumphttpport 8443 --jumpkvmport 5901`
- Avoid port conflicts with already-running services

### Getting Help

If you encounter issues:
1. Run with `--dryrun` to test without launching viewer
2. Check the command being generated (printed before execution)
3. Verify Python version: `python3 --version` (need 3.6+)
4. Verify Java version: `java -version` (recommend 8)
5. Open an issue: https://github.com/stlalpha/idracclient/issues

## License

Original work (c) 2018-2019 Jonas Jelten <jelten@in.tum.de>

Released under GNU GPLv3 or any later version

## Credits

- **Original Author:** Jonas Jelten <jelten@in.tum.de>
- This repository contains modernization updates for Python 3.10+ and Java 9+ compatibility

## Updates in This Fork

- Fixed compatibility with Python 3.10+ (replaced deprecated `asyncio.get_event_loop()`)
- Added `--enable-native-access` flag for Java 9+ compatibility
- Enabled VirtualMedia support (`vm=1` parameter)
- Documented Java 8 requirement for full keyboard/input functionality
- Added cross-platform Java installation instructions (Linux/macOS/Windows)
- Updated documentation with comprehensive usage examples and troubleshooting

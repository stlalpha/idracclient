#!/bin/bash
set -e

# iDRAC KVM Client Installer
# Quick install: curl -sSL https://raw.githubusercontent.com/stlalpha/idracclient/master/install.sh | bash

REPO_URL="https://raw.githubusercontent.com/stlalpha/idracclient/master"
INSTALL_DIR="${HOME}/.local/bin"
SCRIPT_NAME="idracclient"

echo "=== iDRAC KVM Client Installer ==="
echo ""

# Check Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Error: python3 is not installed"
    echo "Please install Python 3.6 or later and try again"
    exit 1
fi

PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
echo "✓ Found Python $PYTHON_VERSION"

# Check Java
if ! command -v java &> /dev/null; then
    echo "⚠️  Warning: java is not installed"
    echo "You'll need Java to run the KVM viewer (Java 8 recommended)"
    echo ""
else
    JAVA_VERSION=$(java -version 2>&1 | head -n 1)
    echo "✓ Found Java: $JAVA_VERSION"
fi

# Create install directory
mkdir -p "$INSTALL_DIR"

# Download script
echo ""
echo "Downloading idracclient.py..."
curl -sSL "$REPO_URL/idracclient.py" -o "$INSTALL_DIR/$SCRIPT_NAME"
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

echo "✓ Installed to $INSTALL_DIR/$SCRIPT_NAME"

# Install Python dependencies
echo ""
echo "Installing Python dependencies..."
if command -v pip3 &> /dev/null; then
    # Check if we're in a virtual environment
    if [[ -n "$VIRTUAL_ENV" ]]; then
        # In venv, don't use --user flag
        pip3 install aiohttp >/dev/null 2>&1 || pip3 install aiohttp
    else
        # Not in venv, use --user flag
        pip3 install --user aiohttp >/dev/null 2>&1 || pip3 install --user aiohttp
    fi
    echo "✓ Installed aiohttp"
else
    echo "⚠️  Warning: pip3 not found, you'll need to install aiohttp manually:"
    echo "   pip3 install aiohttp"
fi

# Check if install dir is in PATH
echo ""
if [[ ":$PATH:" == *":$INSTALL_DIR:"* ]]; then
    echo "✓ $INSTALL_DIR is in your PATH"
else
    echo "⚠️  $INSTALL_DIR is not in your PATH"
    echo ""
    echo "Add this line to your ~/.bashrc or ~/.zshrc:"
    echo "   export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
    echo "Then run: source ~/.bashrc  (or ~/.zshrc)"
fi

echo ""
echo "=== Installation Complete! ==="
echo ""
echo "Usage: $SCRIPT_NAME [options] <hostname>"
echo "Example: $SCRIPT_NAME 192.168.0.132"
echo "Help: $SCRIPT_NAME --help"
echo ""
echo "For full documentation, visit:"
echo "https://github.com/stlalpha/idracclient"

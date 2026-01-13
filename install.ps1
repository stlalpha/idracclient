# iDRAC KVM Client Installer for Windows (PowerShell)
# Quick install: iwr -useb https://raw.githubusercontent.com/stlalpha/idracclient/master/install.ps1 | iex

$ErrorActionPreference = "Stop"

$RepoUrl = "https://raw.githubusercontent.com/stlalpha/idracclient/master"
$InstallDir = "$env:LOCALAPPDATA\idracclient"
$ScriptName = "idracclient.py"

Write-Host "=== iDRAC KVM Client Installer ===" -ForegroundColor Cyan
Write-Host ""

# Check Python
try {
    $PythonVersion = & python --version 2>&1
    Write-Host "✓ Found $PythonVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Error: Python is not installed" -ForegroundColor Red
    Write-Host "Please install Python 3.6 or later from https://www.python.org/" -ForegroundColor Yellow
    Write-Host "Make sure to check 'Add Python to PATH' during installation" -ForegroundColor Yellow
    exit 1
}

# Check Java
try {
    $JavaVersion = & java -version 2>&1 | Select-Object -First 1
    Write-Host "✓ Found Java: $JavaVersion" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Warning: Java is not installed" -ForegroundColor Yellow
    Write-Host "You'll need Java to run the KVM viewer (Java 8 recommended)" -ForegroundColor Yellow
    Write-Host ""
}

# Create install directory
Write-Host ""
Write-Host "Creating installation directory..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

# Download script
Write-Host "Downloading idracclient.py..." -ForegroundColor Cyan
try {
    $WebClient = New-Object System.Net.WebClient
    $WebClient.DownloadFile("$RepoUrl/$ScriptName", "$InstallDir\$ScriptName")
    Write-Host "✓ Installed to $InstallDir\$ScriptName" -ForegroundColor Green
} catch {
    Write-Host "❌ Error downloading script: $_" -ForegroundColor Red
    exit 1
}

# Install Python dependencies
Write-Host ""
Write-Host "Installing Python dependencies..." -ForegroundColor Cyan
try {
    & python -m pip install --user aiohttp --quiet
    Write-Host "✓ Installed aiohttp" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Warning: Failed to install aiohttp" -ForegroundColor Yellow
    Write-Host "Try manually: python -m pip install aiohttp" -ForegroundColor Yellow
}

# Create wrapper batch file
$BatchFile = "$InstallDir\idracclient.bat"
@"
@echo off
python "$InstallDir\$ScriptName" %*
"@ | Out-File -FilePath $BatchFile -Encoding ASCII

# Add to PATH if not already there
Write-Host ""
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -notlike "*$InstallDir*") {
    Write-Host "Adding to PATH..." -ForegroundColor Cyan
    [Environment]::SetEnvironmentVariable(
        "Path",
        "$UserPath;$InstallDir",
        "User"
    )
    Write-Host "✓ Added $InstallDir to PATH" -ForegroundColor Green
    Write-Host ""
    Write-Host "⚠️  You need to restart your terminal for PATH changes to take effect" -ForegroundColor Yellow
} else {
    Write-Host "✓ $InstallDir is already in PATH" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== Installation Complete! ===" -ForegroundColor Green
Write-Host ""
Write-Host "Usage: idracclient [options] <hostname>" -ForegroundColor Cyan
Write-Host "Example: idracclient 192.168.0.132" -ForegroundColor Cyan
Write-Host "Help: idracclient --help" -ForegroundColor Cyan
Write-Host ""
Write-Host "For full documentation, visit:" -ForegroundColor Cyan
Write-Host "https://github.com/stlalpha/idracclient" -ForegroundColor Cyan

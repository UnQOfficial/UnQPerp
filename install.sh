#!/bin/bash
# UnQPerp Installation Script
# Created by: Sandeep Gaddam
# Repository: UnQOfficial/UnQPerp
# Universal OS Support: Linux, macOS, Windows (WSL), Termux, FreeBSD

echo "🚀 UnQPerp Installation Script"
echo "📁 Repository: UnQOfficial/UnQPerp"
echo "🌍 Universal OS & Architecture Support"
echo "================================="
echo ""

# Function to detect OS and architecture
detect_system() {
    # Enhanced Termux detection with multiple methods
    if [ -n "$TERMUX_VERSION" ] || [ -d "/data/data/com.termux" ] || [ "$PREFIX" = "/data/data/com.termux/files/usr" ]; then
        OS="termux"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Additional Android/Termux checks
        if [[ -n "$ANDROID_ROOT" ]] || [[ -n "$PREFIX" ]] || [ -f "/system/bin/getprop" ]; then
            OS="termux"
        else
            OS="linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="darwin"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        OS="windows"
    elif [[ "$OSTYPE" == "freebsd"* ]]; then
        OS="freebsd"
    else
        # Final Android/Termux detection attempt
        if [ -d "/system/app" ] || [ -d "/data/data" ] || [ -f "/proc/version" ]; then
            if grep -q "Android" /proc/version 2>/dev/null; then
                OS="termux"
            else
                OS="unknown"
            fi
        else
            OS="unknown"
        fi
    fi

    # Detect architecture with comprehensive mapping
    ARCH=$(uname -m)
    case $ARCH in
        x86_64|amd64)
            ARCH="amd64"
            ;;
        aarch64|arm64)
            ARCH="arm64"
            ;;
        armv7l|armhf|armv7*)
            ARCH="arm"
            ;;
        i386|i686|i586)
            ARCH="386"
            ;;
        *)
            echo "⚠️  Unknown architecture: $ARCH, defaulting to amd64"
            ARCH="amd64"
            ;;
    esac

    echo "📱 Detected System: $OS"
    echo "🏗️  Detected Architecture: $ARCH"
    echo ""
}

# Function to install cloudflared
install_cloudflared() {
    local download_url=""
    local binary_name=""
    local install_path=""

    # Determine download URL and installation path based on OS and architecture
    case "$OS" in
        "linux")
            case "$ARCH" in
                "amd64") download_url="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64" ;;
                "arm64") download_url="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64" ;;
                "arm") download_url="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm" ;;
                "386") download_url="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386" ;;
                *) echo "❌ Unsupported architecture: $ARCH"; return 1 ;;
            esac
            binary_name="cloudflared-linux-$ARCH"
            install_path="/usr/local/bin/cloudflared"
            ;;
        "termux")
            # Try package manager first with multiple attempts
            echo "📦 Trying Termux package manager..."
            if command -v pkg > /dev/null; then
                echo "🔄 Running: pkg update && pkg install cloudflared"

                # Try updating package lists first
                if pkg update -y; then
                    echo "✅ Package lists updated successfully"
                else
                    echo "⚠️  Package update had issues, continuing..."
                fi

                # Try installing cloudflared
                if pkg install cloudflared -y; then
                    echo "✅ Cloudflared installed via pkg!"
                    return 0
                else
                    echo "⚠️  Package manager installation failed, trying manual installation..."
                fi
            else
                echo "❌ pkg command not found"
            fi

            # Fallback to manual installation for Termux
            case "$ARCH" in
                "arm64") download_url="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64" ;;
                "arm") download_url="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm" ;;
                "amd64") download_url="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64" ;;
                *) echo "❌ Unsupported Termux architecture: $ARCH"; return 1 ;;
            esac
            binary_name="cloudflared-linux-$ARCH"
            install_path="$PREFIX/bin/cloudflared"
            ;;
        "darwin")
            # Try Homebrew first
            if command -v brew > /dev/null; then
                echo "🍺 Installing via Homebrew..."
                if brew install cloudflared; then
                    echo "✅ Cloudflared installed via Homebrew!"
                    return 0
                else
                    echo "⚠️  Homebrew installation failed, trying manual installation..."
                fi
            fi

            # Fallback to manual installation for macOS
            case "$ARCH" in
                "amd64") download_url="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-darwin-amd64.tgz" ;;
                "arm64") download_url="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-darwin-amd64.tgz" ;;
                *) echo "❌ Unsupported macOS architecture: $ARCH"; return 1 ;;
            esac
            binary_name="cloudflared"
            install_path="/usr/local/bin/cloudflared"
            ;;
        "windows")
            case "$ARCH" in
                "amd64") download_url="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.exe" ;;
                "386") download_url="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-386.exe" ;;
                *) echo "❌ Unsupported Windows architecture: $ARCH"; return 1 ;;
            esac
            binary_name="cloudflared-windows-$ARCH.exe"
            install_path="/usr/local/bin/cloudflared.exe"
            ;;
        "freebsd")
            case "$ARCH" in
                "amd64") download_url="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-freebsd-amd64" ;;
                "arm64") download_url="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-freebsd-arm64" ;;
                *) echo "❌ Unsupported FreeBSD architecture: $ARCH"; return 1 ;;
            esac
            binary_name="cloudflared-freebsd-$ARCH"
            install_path="/usr/local/bin/cloudflared"
            ;;
        *)
            echo "❌ Unsupported operating system: $OS"
            echo "💡 Please install cloudflared manually from:"
            echo "   https://github.com/cloudflare/cloudflared/releases"
            echo "📋 Choose the appropriate binary for your system:"
            echo "   - Linux x86_64: cloudflared-linux-amd64"
            echo "   - Linux ARM64: cloudflared-linux-arm64"
            echo "   - macOS: cloudflared-darwin-amd64.tgz"
            echo "   - Windows: cloudflared-windows-amd64.exe"
            return 1
            ;;
    esac

    # Download and install binary
    if [[ -n "$download_url" ]]; then
        echo "📥 Downloading cloudflared..."
        echo "🔗 URL: $download_url"

        # Use appropriate download tool
        if command -v wget > /dev/null; then
            echo "📡 Using wget..."
            if ! wget -q "$download_url" -O "$binary_name"; then
                echo "❌ wget download failed"
                return 1
            fi
        elif command -v curl > /dev/null; then
            echo "📡 Using curl..."
            if ! curl -L -s "$download_url" -o "$binary_name"; then
                echo "❌ curl download failed"
                return 1
            fi
        else
            echo "❌ Neither wget nor curl found. Please install one of them."
            if [[ "$OS" == "termux" ]]; then
                echo "💡 Install with: pkg install wget"
            fi
            return 1
        fi

        # Verify download
        if [ ! -f "$binary_name" ] || [ ! -s "$binary_name" ]; then
            echo "❌ Download failed or file is empty"
            return 1
        fi

        echo "✅ Download completed successfully"

        # Extract if it's a compressed file
        if [[ "$binary_name" == *.tgz ]]; then
            echo "📦 Extracting archive..."
            if tar -xzf "$binary_name"; then
                rm "$binary_name"
                binary_name="cloudflared"
                echo "✅ Archive extracted successfully"
            else
                echo "❌ Failed to extract archive"
                return 1
            fi
        fi

        # Install binary to appropriate location
        echo "🔧 Installing binary..."
        if [[ "$OS" == "termux" ]]; then
            # Termux installation
            if mv "$binary_name" "$install_path" && chmod +x "$install_path"; then
                echo "✅ Installed to $install_path"
            else
                echo "❌ Failed to install to $install_path"
                return 1
            fi
        else
            # Standard Linux/Unix installation
            if command -v sudo > /dev/null; then
                if sudo mv "$binary_name" "$install_path" && sudo chmod +x "$install_path"; then
                    echo "✅ Installed to $install_path"
                else
                    echo "❌ Failed to install to $install_path"
                    return 1
                fi
            else
                # No sudo available, install locally
                echo "⚠️  No sudo available, installing to current directory"
                if chmod +x "$binary_name" && mv "$binary_name" "./cloudflared"; then
                    echo "✅ Installed as ./cloudflared"
                    echo "💡 Add current directory to PATH or move cloudflared manually"
                else
                    echo "❌ Failed local installation"
                    return 1
                fi
            fi
        fi

        echo "🎉 Cloudflared installed successfully!"
        return 0
    else
        echo "❌ No download URL determined"
        return 1
    fi
}

# Check Python version and availability
echo "🐍 Checking Python version..."
if command -v python3 > /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo "✅ Found: $PYTHON_VERSION"
    PYTHON_CMD="python3"
elif command -v python > /dev/null; then
    PYTHON_VERSION=$(python --version)
    echo "✅ Found: $PYTHON_VERSION"
    PYTHON_CMD="python"

    # Check if it's Python 3
    if ! python -c "import sys; sys.exit(0 if sys.version_info >= (3, 7) else 1)" 2>/dev/null; then
        echo "❌ Python version is too old. Python 3.7+ required."
        exit 1
    fi
else
    echo "❌ Python is not installed. Please install Python 3.7 or higher."
    echo "📖 Installation guides:"
    echo "   🐧 Linux: sudo apt install python3 python3-pip"
    echo "   🍎 macOS: brew install python3"
    echo "   📱 Termux: pkg install python"
    echo "   🪟 Windows: Download from python.org"
    exit 1
fi

# Install Python dependencies
echo ""
echo "📦 Installing Python dependencies..."

# Determine appropriate pip command
if command -v pip3 > /dev/null; then
    PIP_CMD="pip3"
elif command -v pip > /dev/null; then
    PIP_CMD="pip"
else
    echo "⚠️  pip not found, attempting to install..."
    if [[ "$OS" == "termux" ]]; then
        if pkg install python-pip -y; then
            echo "✅ pip installed via pkg"
            PIP_CMD="pip"
        else
            echo "❌ Failed to install pip via pkg"
            PIP_CMD="$PYTHON_CMD -m pip"
        fi
    else
        echo "🔧 Installing pip via ensurepip..."
        if $PYTHON_CMD -m ensurepip --upgrade; then
            echo "✅ pip installed via ensurepip"
        else
            echo "⚠️  ensurepip failed, trying alternative method"
        fi
        PIP_CMD="$PYTHON_CMD -m pip"
    fi
fi

echo "📋 Using pip command: $PIP_CMD"

# Install requirements with error handling
if $PIP_CMD install -r requirements.txt; then
    echo "✅ Python dependencies installed successfully"
elif $PIP_CMD install --user -r requirements.txt; then
    echo "✅ Python dependencies installed for user only"
else
    echo "❌ Failed to install Python dependencies"
    echo "💡 Try running manually: $PIP_CMD install --user -r requirements.txt"
    exit 1
fi

# Detect system information
detect_system

# Check if cloudflared is already installed
echo "🌐 Checking Cloudflare tunnel..."
if command -v cloudflared > /dev/null; then
    CLOUDFLARED_VERSION=$(cloudflared --version 2>/dev/null | head -n1)
    echo "✅ Cloudflared is already installed!"
    echo "📋 Version: $CLOUDFLARED_VERSION"
else
    echo "⚠️  Cloudflared not found. Installing..."
    if install_cloudflared; then
        # Verify installation was successful
        if command -v cloudflared > /dev/null; then
            CLOUDFLARED_VERSION=$(cloudflared --version 2>/dev/null | head -n1)
            echo "🎉 Cloudflared installation verified!"
            echo "📋 Version: $CLOUDFLARED_VERSION"
        else
            echo "⚠️  Cloudflared installation completed but command not found in PATH"
        fi
    else
        echo "❌ Cloudflared installation failed"
        echo "💡 You can still run UnQPerp and start tunnel manually:"
        echo "   1. Download cloudflared from: https://github.com/cloudflare/cloudflared/releases"
        echo "   2. Make it executable: chmod +x cloudflared"
        echo "   3. Run: ./cloudflared tunnel --url http://localhost:5000"
        echo ""
    fi
fi

echo ""
echo "🎉 UnQPerp installation completed successfully!"
echo ""
echo "🚀 To start UnQPerp:"
echo "   $PYTHON_CMD server.py"
echo ""
echo "🌐 If auto-tunnel fails, start manually:"
echo "   cloudflared tunnel --url http://localhost:5000"
echo ""
echo "📚 Read the documentation:"
echo "   📖 README.md for project overview"  
echo "   🔧 perplexity.md for AI integration guide"
echo ""
echo "🔗 Repository: https://github.com/UnQOfficial/UnQPerp"
echo "👨‍💻 Created by: Sandeep Gaddam"
echo ""
echo "Happy coding with UnQPerp! 🤖✨"

    # Detect OS and install cloudflared
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
        sudo mv cloudflared-linux-amd64 /usr/local/bin/cloudflared
        sudo chmod +x /usr/local/bin/cloudflared
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        brew install cloudflared
    else
        echo "❌ Unsupported OS. Please install cloudflared manually."
        echo "Download from: https://github.com/cloudflare/cloudflared/releases"
        exit 1
    fi
fi

echo ""
echo "✅ UnQPerp installation completed successfully!"
echo ""
echo "🚀 To start UnQPerp:"
echo "   python3 server.py"
echo ""
echo "📚 Read the documentation:"
echo "   - README.md for project overview"
echo "   - perplexity.md for AI integration guide"
echo ""
echo "🔗 Repository: https://github.com/sandeepgaddam/UnQOfficial"
echo ""
echo "Happy coding with UnQPerp! 🤖✨"

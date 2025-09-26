#!/bin/bash
# UnQPerp Installation Script
# Created by: Sandeep Gaddam
# Repository: UnQOfficial

echo "🚀 UnQPerp Installation Script"
echo "Repository: UnQOfficial"
echo "================================="
echo ""

# Check Python version
echo "🐍 Checking Python version..."
python3 --version

if [ $? -ne 0 ]; then
    echo "❌ Python 3 is not installed. Please install Python 3.7 or higher."
    exit 1
fi

# Install Python dependencies
echo ""
echo "📦 Installing Python dependencies..."
pip3 install -r requirements.txt

if [ $? -ne 0 ]; then
    echo "❌ Failed to install Python dependencies."
    exit 1
fi

# Check if cloudflared is installed
echo ""
echo "🌐 Checking Cloudflare tunnel..."
which cloudflared > /dev/null

if [ $? -ne 0 ]; then
    echo "⚠️  Cloudflared not found. Installing..."

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

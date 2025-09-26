# 🚀 UnQPerp - AI CodeBase Bridge

**Repository:** [UnQPerp](https://github.com/UnQOfficial/UnQPerp)  
**Created by:** [Sandeep Gaddam](https://github.com/UnQOfficial)  
**Version:** 1.0.0  
**License:** MIT

## 📖 Overview
UnQPerp is a powerful Flask-based server that enables AI assistants (like Perplexity) to directly access and manage your local codebase through secure Cloudflare tunnels. Bridge the gap between AI and your development environment with seamless integration.

## ✨ Features

### 🔧 Core Functionality
- **Complete File Management** - Read, write, create, delete files and directories
- **Multi-Language Code Execution** - Python, Node.js, Bash support with real-time output
- **Package Management** - Install pip and npm packages on-demand
- **Git Integration** - Perform version control operations safely
- **Advanced Search** - Find code patterns across your entire codebase
- **Directory Navigation** - Browse project structure with tree view
- **File Renaming** - Rename files and directories remotely

### 🌐 Remote Access
- **Auto Cloudflare Tunnel** - Automatic tunnel startup with server
- **REST API** - Complete HTTP API for all operations
- **CORS Enabled** - Cross-origin requests supported
- **Real-time Updates** - Changes reflect immediately
- **Secure Access** - Encrypted tunnel connection

## 📦 Installation

### Method 1: Quick Install (Recommended)

#### Prerequisites
- **Python 3.7+** installed on your system
- **Git** installed for version control features
- **Internet connection** for Cloudflare tunnel

#### Step 1: Clone Repository
```bash
git clone https://github.com/UnQOfficial/UnQPerp.git
cd UnQPerp
```

#### Step 2: Install Python Dependencies
```bash
pip install -r requirements.txt
```

#### Step 3: Install Cloudflare Tunnel
**For Linux/Ubuntu:**
```bash
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
sudo mv cloudflared-linux-amd64 /usr/local/bin/cloudflared
sudo chmod +x /usr/local/bin/cloudflared
```

**For macOS:**
```bash
brew install cloudflared
```

**For Windows:**
1. Download from: https://github.com/cloudflare/cloudflared/releases
2. Extract and add to PATH

#### Step 4: Start UnQPerp
```bash
python server.py
```

✅ **That's it!** Server will start automatically with Cloudflare tunnel.

### Method 2: Automated Installation

#### For Linux/macOS/Termux(Android):
```bash
git clone https://github.com/UnQOfficial/UnQPerp.git
cd UnQPerp
chmod +x install.sh
./install.sh
python server.py
```

#### For Windows PowerShell:
```powershell
git clone https://github.com/UnQOfficial/UnQPerp.git
cd UnQPerp
pip install -r requirements.txt
python server.py
```

### Method 3: Python Package Installation
```bash
pip install git+https://github.com/UnQOfficial/UnQPerp.git
unqperp
```

## 🚀 Quick Start Guide

### 1. **Start the Server**
```bash
python server.py
```

You'll see output like:
```
╔══════════════════════════════════════════════════════════════╗
║                         🚀 UnQPerp v1.0.0                               ║
║                   AI CodeBase Bridge Server                             ║
║                                                                         ║
║  Created by: Sandeep Gaddam                                             ║
║  GitHub: https://github.com/UnQOfficial                                 ║
╚══════════════════════════════════════════════════════════════╝

📁 Base Directory: /your/project/path
🌐 Server starting at: http://localhost:5000
🌐 Starting Cloudflare tunnel...
✅ Cloudflare tunnel started successfully!
```

### 2. **Get Your Tunnel URL**
The server will automatically generate a Cloudflare tunnel URL like:
```
https://random-words-domain.trycloudflare.com
```

### 3. **Test Connection**
Open your browser and visit: `your-tunnel-url/api/status`

You should see JSON response with server information.

### 4. **AI Integration**
Use the tunnel URL with your AI assistant. See `perplexity.md` for detailed API documentation.

## 📁 Project Structure
```
UnQOfficial/
├── server.py                     # Main UnQPerp server
├── perplexity.md                 # AI integration guide
├── README.md                     # This file
├── requirements.txt              # Python dependencies
├── LICENSE                       # MIT License
├── .gitignore                    # Git ignore patterns
├── setup.py                      # Python package setup
└── install.sh                    # Automated installation script
```

## 🎯 Usage Examples

### Basic File Operations
```bash
# List files
curl https://your-tunnel-url/api/files

# Read a file
curl https://your-tunnel-url/api/files/script.py

# Create a file
curl -X POST https://your-tunnel-url/api/files/new_file.py \
  -H "Content-Type: application/json" \
  -d '{"content": "print("Hello UnQPerp!")"}'
```

### Code Execution
```bash
# Execute Python code
curl -X POST https://your-tunnel-url/api/execute \
  -H "Content-Type: application/json" \
  -d '{"code": "print("Hello World!")", "language": "python"}'
```

### Git Operations
```bash
# Check git status
curl -X POST https://your-tunnel-url/api/git \
  -H "Content-Type: application/json" \
  -d '{"command": "status"}'
```

## 🤖 AI Assistant Integration

### Perplexity AI Setup
1. **Create a Perplexity Space** for your project
2. **Add Custom Instructions:**
   ```
   You have access to my codebase at [YOUR_TUNNEL_URL]

   First, read the documentation:
   - GET /api/status for server info
   - Read perplexity.md for complete API guide

   You can manage files, execute code, install packages, and perform git operations.
   Always check server status before starting work.
   ```
3. **Start collaborating** with AI on your codebase!

### Other AI Tools
- **ChatGPT:** Use with function calling or plugins
- **Claude:** Integrate via API calls
- **GitHub Copilot:** Connect through webhooks
- **Custom AI Apps:** Use the REST API directly

## 🔐 Security Features
- **Local Control** - Server runs on your machine
- **Encrypted Tunnel** - Cloudflare provides secure connection
- **Command Filtering** - Dangerous operations are blocked
- **Directory Scoping** - Access limited to project directory
- **Safe Git Operations** - Only approved git commands allowed
- **Timeout Protection** - Code execution limited to 30 seconds

## 🛠️ System Requirements

### Minimum Requirements
- **OS:** Windows 10, macOS 10.14, Ubuntu 18.04 or newer
- **Python:** 3.7 or higher
- **RAM:** 256MB available memory
- **Storage:** 100MB free space
- **Network:** Stable internet connection

### Recommended Requirements
- **OS:** Latest version of your operating system
- **Python:** 3.9 or higher
- **RAM:** 1GB available memory
- **Storage:** 500MB free space
- **Network:** Broadband internet connection

## 🔄 Development Workflow
1. **Initialize** - Start UnQPerp server with `python server.py`
2. **Connect** - AI automatically gets tunnel URL
3. **Explore** - AI reads project structure and documentation
4. **Collaborate** - Work together on coding tasks
5. **Test** - Execute code changes in real-time
6. **Commit** - Version control via git integration
7. **Deploy** - AI assists with deployment processes

## 🚨 Troubleshooting

### Common Issues

#### Server Won't Start
```bash
# Check Python version
python --version

# Install dependencies
pip install -r requirements.txt

# Run with verbose output
python server.py --debug
```

#### Cloudflare Tunnel Issues
```bash
# Check if cloudflared is installed
cloudflared --version

# Manual tunnel start
cloudflared tunnel --url http://localhost:5000
```

#### Connection Problems
- Ensure firewall allows connections on port 5000
- Check if another service is using port 5000
- Verify internet connection is stable

#### Permission Errors
```bash
# On Linux/macOS, ensure proper permissions
chmod +x install.sh
sudo chown -R $USER:$USER .
```

### Getting Help
- **Issues:** Report bugs at [GitHub Issues](https://github.com/UnQOfficial/issues)
- **Discussions:** Join discussions at [GitHub Discussions](https://github.com/UnQOfficial/discussions)
- **Documentation:** Read `perplexity.md` for detailed API guide

## 🎉 Benefits
- **10x Productivity** - AI handles routine development tasks
- **Continuous Learning** - AI explains complex code and patterns
- **Error Prevention** - Real-time code analysis and suggestions
- **24/7 Availability** - Development assistance anytime, anywhere
- **Context Awareness** - AI understands your entire codebase
- **Best Practices** - AI enforces coding standards and conventions

## 🤝 Contributing
Contributions are welcome! Please feel free to:
- Submit pull requests
- Report issues or bugs
- Suggest new features
- Improve documentation
- Share usage examples

### Development Setup
```bash
git clone https://github.com/UnQOfficial/UnQPerp.git
cd UnQPerp
pip install -r requirements.txt
pip install -e .  # Install in development mode
```

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments
- **Cloudflare** for providing secure tunnel infrastructure
- **Flask** community for the excellent web framework
- **AI development community** for inspiration and feedback
- **Open source contributors** who make projects like this possible

## 📞 Contact
- **GitHub:** [@UnQOfficial](https://github.com/UnQOfficial)
- **Repository:** [UnQOfficial](https://github.com/UnQOfficial/UnQPerp)
- **Issues:** [Report Issues](https://github.com/UnQOfficial/UnQPerp/issues)

---
**Happy Coding with UnQPerp! 🤖✨**

*Created with ❤️ by Sandeep Gaddam*

*Part of the UnQOfficial project suite*

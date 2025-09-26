#!/usr/bin/env python3
"""
UnQPerp - AI CodeBase Bridge
Created by: Sandeep Gaddam
GitHub: https://github.com/UnQOfficial/UnQPerp

A powerful tool that enables AI assistants to directly access and manage
your local codebase through secure Cloudflare tunnels.
"""

from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
import os
import subprocess
import json
import shutil
from pathlib import Path
import mimetypes
import sys
import traceback
import threading
import time

app = Flask(__name__)
CORS(app)

# Tool Information
TOOL_NAME = "UnQPerp"
TOOL_VERSION = "1.0.0"
AUTHOR = "Sandeep Gaddam"
GITHUB_URL = "https://github.com/UnQOfficial/UnQPerp"

# Base directory for code operations
BASE_DIR = os.getcwd()

def start_cloudflare_tunnel():
    """Start Cloudflare tunnel automatically and capture URL"""
    try:
        print("🌐 Starting Cloudflare tunnel...")

        # Start tunnel process
        tunnel_process = subprocess.Popen([
            'cloudflared', 'tunnel', '--url', 'http://localhost:5000'
        ], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

        # Monitor tunnel output for URL
        tunnel_url = None
        timeout = 15  # Wait up to 15 seconds for URL
        start_time = time.time()

        while time.time() - start_time < timeout:
            if tunnel_process.poll() is not None:
                # Process has terminated
                stderr_output = tunnel_process.stderr.read()
                print(f"❌ Tunnel process terminated: {stderr_output}")
                break

            # Try to read a line from stderr (where cloudflared outputs the URL)
            try:
                line = tunnel_process.stderr.readline()
                if line:
                    print(f"🔍 Tunnel output: {line.strip()}")
                    # Look for the tunnel URL in the output
                    if "trycloudflare.com" in line:
                        import re
                        url_match = re.search(r'https://[\w-]+\.trycloudflare\.com', line)
                        if url_match:
                            tunnel_url = url_match.group(0)
                            break
            except:
                pass

            time.sleep(0.5)

        if tunnel_url:
            print(f"✅ Cloudflare tunnel started successfully!")
            print(f"🔗 Tunnel URL: {tunnel_url}")
            print(f"📋 Test URL: {tunnel_url}/api/status")

            # Save tunnel URL to file for reference
            with open('.tunnel_url', 'w') as f:
                f.write(tunnel_url)

        else:
            print("⚠️  Tunnel started but URL not detected")
            print("💡 Check tunnel status manually with: cloudflared tunnel --url http://localhost:5000")

        return tunnel_process

    except FileNotFoundError:
        print("❌ cloudflared not found. Please install cloudflared first:")
        print("💡 Run: ./updated_install.sh")
        return None
    except Exception as e:
        print(f"❌ Failed to start tunnel: {e}")
        print("💡 Make sure cloudflared is installed and accessible")
        return None

@app.route('/api/status', methods=['GET'])
def status():
    """Server status check with tool information"""
    tunnel_url = ""
    try:
        if os.path.exists('.tunnel_url'):
            with open('.tunnel_url', 'r') as f:
                tunnel_url = f.read().strip()
    except:
        pass

    return jsonify({
        'tool_name': TOOL_NAME,
        'version': TOOL_VERSION,
        'author': AUTHOR,
        'github': GITHUB_URL,
        'tunnel_url': tunnel_url,
        'status': 'active',
        'base_dir': BASE_DIR,
        'python_version': sys.version,
        'available_endpoints': [
            '/api/files',
            '/api/files/<path:filepath>',
            '/api/execute',
            '/api/install',
            '/api/git',
            '/api/search',
            '/api/tree',
            '/api/rename'
        ]
    })

@app.route('/api/files', methods=['GET'])
def list_files():
    """List all files and directories"""
    try:
        path = request.args.get('path', BASE_DIR)
        items = []

        for item in os.listdir(path):
            item_path = os.path.join(path, item)
            is_dir = os.path.isdir(item_path)
            size = os.path.getsize(item_path) if not is_dir else 0

            items.append({
                'name': item,
                'path': item_path,
                'type': 'directory' if is_dir else 'file',
                'size': size,
                'extension': os.path.splitext(item)[1] if not is_dir else None
            })

        return jsonify({'files': items, 'current_path': path})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/files/<path:filepath>', methods=['GET', 'POST', 'PUT', 'DELETE'])
def file_operations(filepath):
    """Complete file operations"""
    full_path = os.path.join(BASE_DIR, filepath)

    try:
        if request.method == 'GET':
            # Read file content
            if os.path.isfile(full_path):
                with open(full_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                return jsonify({
                    'content': content,
                    'path': full_path,
                    'size': os.path.getsize(full_path),
                    'type': mimetypes.guess_type(full_path)[0]
                })
            else:
                return jsonify({'error': 'File not found'}), 404

        elif request.method == 'POST' or request.method == 'PUT':
            # Create or update file
            data = request.get_json()
            content = data.get('content', '')

            # Create directory if doesn't exist
            os.makedirs(os.path.dirname(full_path), exist_ok=True)

            with open(full_path, 'w', encoding='utf-8') as f:
                f.write(content)

            return jsonify({
                'message': 'File saved successfully',
                'path': full_path,
                'size': len(content)
            })

        elif request.method == 'DELETE':
            # Delete file or directory
            if os.path.isfile(full_path):
                os.remove(full_path)
                return jsonify({'message': 'File deleted successfully'})
            elif os.path.isdir(full_path):
                shutil.rmtree(full_path)
                return jsonify({'message': 'Directory deleted successfully'})
            else:
                return jsonify({'error': 'File not found'}), 404

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/rename', methods=['POST'])
def rename_file():
    """Rename files and directories"""
    try:
        data = request.get_json()
        old_path = os.path.join(BASE_DIR, data.get('old_name', ''))
        new_path = os.path.join(BASE_DIR, data.get('new_name', ''))

        if os.path.exists(old_path):
            os.rename(old_path, new_path)
            return jsonify({
                'message': 'File renamed successfully',
                'old_path': old_path,
                'new_path': new_path
            })
        else:
            return jsonify({'error': 'File not found'}), 404

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/execute', methods=['POST'])
def execute_code():
    """Execute code in various languages"""
    try:
        data = request.get_json()
        code = data.get('code', '')
        language = data.get('language', 'python')
        filename = data.get('filename', 'temp')

        if language == 'python':
            # Execute Python code
            result = subprocess.run([sys.executable, '-c', code], 
                                  capture_output=True, text=True, timeout=30)
            return jsonify({
                'output': result.stdout,
                'error': result.stderr,
                'return_code': result.returncode
            })

        elif language == 'node':
            # Execute Node.js code
            with open(f'{filename}.js', 'w') as f:
                f.write(code)
            result = subprocess.run(['node', f'{filename}.js'], 
                                  capture_output=True, text=True, timeout=30)
            os.remove(f'{filename}.js')
            return jsonify({
                'output': result.stdout,
                'error': result.stderr,
                'return_code': result.returncode
            })

        elif language == 'bash':
            # Execute bash commands
            result = subprocess.run(code, shell=True, 
                                  capture_output=True, text=True, timeout=30)
            return jsonify({
                'output': result.stdout,
                'error': result.stderr,
                'return_code': result.returncode
            })

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/install', methods=['POST'])
def install_package():
    """Install packages via pip/npm"""
    try:
        data = request.get_json()
        package = data.get('package', '')
        manager = data.get('manager', 'pip')

        if manager == 'pip':
            result = subprocess.run([sys.executable, '-m', 'pip', 'install', package], 
                                  capture_output=True, text=True)
        elif manager == 'npm':
            result = subprocess.run(['npm', 'install', package], 
                                  capture_output=True, text=True)

        return jsonify({
            'output': result.stdout,
            'error': result.stderr,
            'return_code': result.returncode
        })

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/git', methods=['POST'])
def git_operations():
    """Git operations"""
    try:
        data = request.get_json()
        command = data.get('command', '')

        # Safety check for git commands
        allowed_commands = ['status', 'add', 'commit', 'push', 'pull', 'log', 'diff', 'init']
        if not any(cmd in command for cmd in allowed_commands):
            return jsonify({'error': 'Git command not allowed'}), 403

        result = subprocess.run(f'git {command}', shell=True, 
                              capture_output=True, text=True)
        return jsonify({
            'output': result.stdout,
            'error': result.stderr,
            'return_code': result.returncode
        })

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/search', methods=['POST'])
def search_code():
    """Search through codebase"""
    try:
        data = request.get_json()
        query = data.get('query', '')
        file_type = data.get('file_type', '*')

        matches = []
        for root, dirs, files in os.walk(BASE_DIR):
            for file in files:
                if file_type != '*' and not file.endswith(file_type):
                    continue

                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                        if query.lower() in content.lower():
                            lines = content.split('\n')
                            for i, line in enumerate(lines):
                                if query.lower() in line.lower():
                                    matches.append({
                                        'file': file_path,
                                        'line_number': i + 1,
                                        'line_content': line.strip(),
                                        'context': lines[max(0, i-2):i+3]
                                    })
                except:
                    continue

        return jsonify({'matches': matches, 'total': len(matches)})

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/tree', methods=['GET'])
def directory_tree():
    """Get complete directory tree"""
    def get_tree(path, max_depth=3, current_depth=0):
        if current_depth >= max_depth:
            return None

        tree = {'name': os.path.basename(path), 'path': path, 'children': []}

        try:
            if os.path.isdir(path):
                for item in sorted(os.listdir(path)):
                    if item.startswith('.'):
                        continue
                    item_path = os.path.join(path, item)
                    subtree = get_tree(item_path, max_depth, current_depth + 1)
                    if subtree:
                        tree['children'].append(subtree)
        except PermissionError:
            pass

        return tree

    try:
        tree = get_tree(BASE_DIR)
        return jsonify(tree)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    print(f"""
╔════════════════════════════════════════════════════╗
║                         🚀 {TOOL_NAME} v{TOOL_VERSION}      ║
║                   AI CodeBase Bridge Server                 ║
║                                                             ║
║  Created by: {AUTHOR}                                       ║
║  GitHub: {GITHUB_URL}                                       ║
╚════════════════════════════════════════════════════╝

📁 Base Directory: {BASE_DIR}
🌐 Server starting at: http://localhost:5000

🔗 Available Endpoints:
   • GET  /api/status          - Server status & tool info
   • GET  /api/files           - List files and directories  
   • GET  /api/files/<path>    - Read file content
   • POST /api/files/<path>    - Create new file
   • PUT  /api/files/<path>    - Update existing file
   • DELETE /api/files/<path>  - Delete file/directory
   • POST /api/rename          - Rename files/directories
   • POST /api/execute         - Execute code (Python/Node/Bash)
   • POST /api/install         - Install packages (pip/npm)
   • POST /api/git             - Git operations
   • POST /api/search          - Search codebase
   • GET  /api/tree            - Directory tree view
""")

    # Start tunnel in background
    tunnel_thread = threading.Thread(target=start_cloudflare_tunnel)
    tunnel_thread.daemon = True
    tunnel_thread.start()

    # Give tunnel a moment to start
    time.sleep(2)

    # Start Flask server
    app.run(host='0.0.0.0', port=5000, debug=False)

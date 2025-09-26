# 🤖 UnQPerp - Perplexity AI Integration Guide

**Tool:** UnQPerp v1.0.0  
**Created by:** Sandeep Gaddam  
**Purpose:** AI CodeBase Bridge for seamless development collaboration

## 🌐 Server Connection
**Base URL:** Your Cloudflare tunnel URL (auto-generated when server starts)  
**Status Check:** `GET /api/status`

## 📋 Complete API Reference

### 🔍 Server Status & Tool Information
```http
GET /api/status
```
**Response includes:**
- Tool name, version, and author information
- Server status and base directory
- Python version and available endpoints
- GitHub repository link

### 📁 File Management Operations

#### List Directory Contents
```http
GET /api/files
GET /api/files?path=/specific/directory
```
**Returns:** Array of files with name, size, type, and extension

#### Read File Content
```http
GET /api/files/filename.py
GET /api/files/folder/subfolder/file.txt
```
**Returns:** File content, size, path, and MIME type

#### Create New File
```http
POST /api/files/new_file.py
Content-Type: application/json

{
  "content": "# New Python file\nprint('Hello UnQPerp!')"
}
```

#### Update Existing File
```http
PUT /api/files/existing_file.py
Content-Type: application/json

{
  "content": "# Updated content\nprint('Modified by AI!')"
}
```

#### Delete File or Directory
```http
DELETE /api/files/filename.py
DELETE /api/files/directory_name
```

#### Rename File or Directory
```http
POST /api/rename
Content-Type: application/json

{
  "old_name": "old_file.py",
  "new_name": "new_file.py"
}
```

### 🚀 Code Execution Engine
```http
POST /api/execute
Content-Type: application/json

{
  "code": "print('Hello from UnQPerp!')",
  "language": "python",
  "filename": "test_script"
}
```

**Supported Languages:**
- `python` - Python 3.x execution
- `node` - Node.js JavaScript execution  
- `bash` - Shell command execution

**Response Format:**
```json
{
  "output": "Hello from UnQPerp!",
  "error": "",
  "return_code": 0
}
```

### 📦 Package Management
```http
POST /api/install
Content-Type: application/json

{
  "package": "requests",
  "manager": "pip"
}
```

**Supported Managers:**
- `pip` - Python packages
- `npm` - Node.js packages

### 🔧 Git Version Control
```http
POST /api/git
Content-Type: application/json

{
  "command": "status"
}
```

**Safe Git Commands:**
- `status` - Check repository status
- `add .` - Stage all changes
- `commit -m "message"` - Commit with message
- `push` - Push to remote repository
- `pull` - Pull from remote repository
- `log --oneline` - View commit history
- `diff` - Show changes
- `init` - Initialize repository

### 🔍 Codebase Search
```http
POST /api/search
Content-Type: application/json

{
  "query": "function_name",
  "file_type": ".py"
}
```

**Search Options:**
- `query` - Text to search for
- `file_type` - File extension filter (use "*" for all files)

**Response:**
```json
{
  "matches": [
    {
      "file": "/path/to/file.py",
      "line_number": 15,
      "line_content": "def function_name():",
      "context": ["line 13", "line 14", "def function_name():", "line 16", "line 17"]
    }
  ],
  "total": 1
}
```

### 🌳 Project Structure
```http
GET /api/tree
```
**Returns:** Hierarchical directory tree (3 levels deep)

## 🎯 AI Collaboration Workflow

### 1. Initial Connection
```
Start by checking server status to confirm connection:
GET /api/status

This provides tool information and available endpoints.
```

### 2. Project Exploration
```
Understand the project structure:
GET /api/tree

Then explore key files:
GET /api/files/README.md
GET /api/files/requirements.txt
```

### 3. Code Analysis
```
Search for specific patterns or functions:
POST /api/search
{
  "query": "class",
  "file_type": ".py"
}
```

### 4. File Operations
```
Read existing code:
GET /api/files/main.py

Make modifications:
PUT /api/files/main.py
{
  "content": "improved code here"
}
```

### 5. Testing Changes
```
Execute modified code:
POST /api/execute
{
  "code": "content from file",
  "language": "python"
}
```

### 6. Dependency Management
```
Install required packages:
POST /api/install
{
  "package": "numpy",
  "manager": "pip"
}
```

### 7. Version Control
```
Commit changes:
POST /api/git
{
  "command": "add ."
}

POST /api/git
{
  "command": "commit -m 'AI-assisted improvements'"
}
```

## ⚡ Quick Action Examples

### Create Python Script
```http
POST /api/files/ai_helper.py
{
  "content": "#!/usr/bin/env python3\n# AI-generated helper script\n\ndef main():\n    print('Created by UnQPerp AI!')\n\nif __name__ == '__main__':\n    main()"
}
```

### Execute and Test
```http
POST /api/execute
{
  "code": "exec(open('ai_helper.py').read())",
  "language": "python"
}
```

### Search for TODOs
```http
POST /api/search
{
  "query": "TODO",
  "file_type": "*"
}
```

### Check Git Status
```http
POST /api/git
{
  "command": "status"
}
```

## 🔐 Security Guidelines

### Safe Operations
- File operations are restricted to the base directory
- Git commands are filtered to prevent dangerous operations
- Code execution has timeout protection (30 seconds)
- All paths are validated and sanitized

### Best Practices
1. **Always verify** server status before starting work
2. **Read existing files** to understand context before modifications  
3. **Test changes** immediately using the execute endpoint
4. **Use search** to find existing implementations and patterns
5. **Commit frequently** using git operations
6. **Install dependencies** only when necessary
7. **Monitor file sizes** to avoid creating overly large files

### Command Safety
- **Allowed Git Commands:** Only safe, read-only or standard operations
- **Path Restrictions:** Cannot access files outside base directory
- **Execution Timeout:** All code execution limited to 30 seconds
- **Error Handling:** Comprehensive error catching and reporting

## 🚨 Important Notes

### Connection Requirements
- Server must be running locally with active Cloudflare tunnel
- All API requests require JSON Content-Type header
- File paths are relative to the server's base directory
- Tunnel URL changes each time server restarts

### File Handling
- UTF-8 encoding assumed for text files
- Binary files may not be handled correctly via API
- Large files should be processed in chunks
- Always backup important changes via git

### Performance Considerations
- Directory listings may be slow for large projects
- Search operations scan all files (may take time)
- Code execution is synchronous (blocks until complete)
- File operations are atomic (safe from corruption)

## 🎉 Advanced Tips

### Multi-step Operations
1. Combine file reading with search for comprehensive analysis
2. Use git status before making changes to understand current state
3. Execute code after every significant change to catch errors early
4. Use tree view to understand project architecture

### Efficient Workflows
- Search before creating to avoid duplication
- Read similar files for consistent coding patterns
- Use git log to understand project history
- Install dependencies proactively based on code analysis

### Error Recovery
- Check server status if requests fail
- Verify file paths are correct and accessible
- Ensure proper JSON formatting in request bodies
- Monitor git operations for merge conflicts

---
**Ready to collaborate with UnQPerp! 🚀**

*AI-Powered Development Made Simple*

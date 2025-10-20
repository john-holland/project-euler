# 🚀 Cursor Code Installation Guide

## Prerequisites

- **Haxe 4.0+** - [Download Haxe](https://haxe.org/download/)
- **Node.js 14+** - [Download Node.js](https://nodejs.org/) (for Node.js builds)
- **Neko 2.0+** - [Download Neko](https://nekovm.org/) (for Neko builds)

## Installation Methods

### 📦 Method 1: Via Haxelib (Recommended)

```bash
# Install from haxelib (once published)
haxelib install cursor-code

# Or install from git
haxelib git cursor-code https://github.com/cursor-code/cursor-code.git

# Set up development version
haxelib dev cursor-code /path/to/cursor-code
```

### 🔧 Method 2: Via NPM

```bash
# Install globally for command line usage
npm install -g cursor-code

# Or install locally in project
npm install cursor-code
```

### 🛠️ Method 3: From Source

```bash
# Clone the repository
git clone https://github.com/cursor-code/cursor-code.git
cd cursor-code

# Install dependencies and build
./build.sh

# Set up for development
haxelib dev cursor-code .
```

## Build Targets

### 🎯 Neko Target (Default)

Best for development and local usage:

```bash
# Build Neko versions
haxe build.hxml

# Use Neko commands
neko cursor-code.n init
neko cursor-code.n status
neko cursor-coda-server.n
```

### 🟢 Node.js Target

Best for production and distribution:

```bash
# Build Node.js versions
npm run build-node
npm run build-lib

# Use Node.js commands
node cursor-code.js init
node cursor-code.js status
node cursor-coda-server.js

# Or via npm scripts
npm run init
npm run status
npm run server
```

## Quick Start

### 1. **Build Everything**
```bash
./build.sh
```

### 2. **Initialize System**
```bash
# With Neko
neko cursor-code.n init

# With Node.js
node cursor-code.js init

# With npm
npm run init
```

### 3. **Create Your First Coda**
```bash
# Interactive setup
cursor-code create
```

### 4. **Start Using**
```bash
# Get guidance
cursor-code guidance problem_analysis

# Check status
cursor-code status

# Start web server
cursor-code server
```

## Installation Verification

### Test Neko Build
```bash
neko cursor-code.n --help
neko cursor-code-tests.n
```

### Test Node.js Build
```bash
node cursor-code.js --help
node cursor-code-tests.js
```

### Test NPM Scripts
```bash
npm run test
npm run status
```

## Dependencies

### Haxe Libraries
- `yaml` - YAML parsing support
- `hxnodejs` - Node.js integration
- `sys` - System integration
- `haxe-json` - JSON handling

### Node.js Dependencies
- `js-yaml` - YAML parsing for Node.js

## Development Setup

### 1. **Install Development Dependencies**
```bash
# Haxe libraries
haxelib install yaml
haxelib install hxnodejs
haxelib install sys
haxelib install haxe-json

# Node.js dependencies
npm install
```

### 2. **Set Up Development Environment**
```bash
# Link for development
haxelib dev cursor-code .

# Build and test
./build.sh
npm run test
```

### 3. **Create Development Workspace**
```bash
# Initialize with test data
cursor-code init test-frontmatter.yaml

# Run development server
npm run dev
```

## Platform-Specific Notes

### macOS
```bash
# Install Haxe via Homebrew
brew install haxe

# Build and run
./build.sh
```

### Linux
```bash
# Install Haxe via package manager
sudo apt install haxe  # Ubuntu/Debian
sudo yum install haxe  # CentOS/RHEL

# Build and run
./build.sh
```

### Windows
```powershell
# Install Haxe from haxe.org
# Then in PowerShell/CMD:
haxe build.hxml
node cursor-code.js init
```

## Troubleshooting

### Common Issues

**Build Fails:**
```bash
# Check Haxe installation
haxe --version

# Reinstall dependencies
npm run install-deps
```

**Missing Libraries:**
```bash
# Install all Haxe dependencies
haxelib install yaml
haxelib install hxnodejs
haxelib install sys
haxelib install haxe-json
```

**Node.js Issues:**
```bash
# Check Node.js version (needs 14+)
node --version

# Reinstall Node.js dependencies
npm install
```

**Permission Issues:**
```bash
# Make scripts executable
chmod +x build.sh
chmod +x demo.sh
chmod +x create-node-bins.sh
```

### Debug Mode

Enable debug output:
```bash
# Verbose build
haxe build.hxml -v

# Debug runs
DEBUG=1 cursor-code init
```

## Configuration

### Environment Variables
- `CURSOR_CODE_CONFIG` - Path to custom coda file
- `CURSOR_CODE_DEBUG` - Enable debug mode
- `CURSOR_CODE_LOG_LEVEL` - Set logging level

### Config Files
- `cursor-coda.yaml` - Main configuration
- `.cursor-code-state.json` - Persistent state
- `.cursor-update-log.txt` - Update detection log

## Next Steps

1. **Read the Documentation**: Check `README.md` and `USAGE_EXAMPLES.md`
2. **Run the Demo**: `./demo.sh` for a complete walkthrough
3. **Explore Examples**: Look at the test files and examples
4. **Customize**: Edit `cursor-coda.yaml` for your project needs
5. **Integrate**: Use with your existing development workflow

## Distribution

### Publishing to Haxelib
```bash
# Prepare for publishing
npm run prepublish

# Submit to haxelib
haxelib submit cursor-code-1.0.0.zip
```

### Publishing to NPM
```bash
# Build and test
npm run build
npm run test

# Publish
npm publish
```

## Support

- **Documentation**: See `README.md` and other docs
- **Issues**: Report bugs via GitHub issues
- **Examples**: Check `USAGE_EXAMPLES.md`
- **Demo**: Run `./demo.sh` for interactive demonstration
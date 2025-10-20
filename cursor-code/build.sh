#!/bin/bash

echo "🎯 Building Cursor Code..."

# Install dependencies
echo "📦 Installing Haxe libraries..."
haxelib install yaml --quiet
haxelib install hxnodejs --quiet
haxelib install sys --quiet
haxelib install haxe-json --quiet

# Install Node.js dependencies
echo "📦 Installing Node.js dependencies..."
npm install js-yaml

# Build the project
echo "🔨 Building Haxe project (both Neko and Node.js targets)..."
haxe build.hxml

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo ""
    echo "🎯 Neko targets built:"
    echo "  cursor-code.n"
    echo "  cursor-code-tests.n"
    echo "  cursor-coda-server.n"
    echo ""
    echo "🟢 Node.js targets built:"
    echo "  cursor-code.js"
    echo "  cursor-code-tests.js"
    echo "  cursor-coda-server.js"
    echo "  lib/cursor-code-lib.js"
    echo ""
    echo "📋 Available commands (Neko):"
    echo "  neko cursor-code.n init     - Initialize system"
    echo "  neko cursor-code.n create   - Create new coda"
    echo "  neko cursor-code.n status   - Show status"
    echo "  neko cursor-code.n guidance <section> - Get guidance"
    echo "  neko cursor-coda-server.n   - Start web server"
    echo ""
    echo "📋 Available commands (Node.js):"
    echo "  node cursor-code.js init     - Initialize system"
    echo "  node cursor-code.js create   - Create new coda"
    echo "  node cursor-code.js status   - Show status"
    echo "  node cursor-code.js guidance <section> - Get guidance"
    echo "  node cursor-coda-server.js   - Start web server"
    echo ""
    echo "📦 NPM scripts available:"
    echo "  npm run init      - Initialize with Node.js"
    echo "  npm run test      - Run tests with Node.js"
    echo "  npm run server    - Start web server with Node.js"
    echo "  npm run dev       - Build and initialize"
    echo ""
    echo "🌐 To start the web interface:"
    echo "  node cursor-coda-server.js"
    echo "  Then visit http://localhost:8080"
    echo ""
    echo "📚 For haxelib distribution:"
    echo "  haxelib dev cursor-code ."
else
    echo "❌ Build failed!"
    exit 1
fi
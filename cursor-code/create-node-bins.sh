#!/bin/bash

echo "🔧 Creating Node.js executable binaries..."

# Create executable wrapper for cursor-code.js
cat > cursor-code << 'EOF'
#!/usr/bin/env node
require('./cursor-code.js');
EOF

# Create executable wrapper for cursor-code-tests.js  
cat > cursor-code-test << 'EOF'
#!/usr/bin/env node
require('./cursor-code-tests.js');
EOF

# Create executable wrapper for cursor-coda-server.js
cat > cursor-coda-server << 'EOF'
#!/usr/bin/env node
require('./cursor-coda-server.js');
EOF

# Make them executable
chmod +x cursor-code
chmod +x cursor-code-test
chmod +x cursor-coda-server

echo "✅ Node.js executable binaries created:"
echo "  ./cursor-code"
echo "  ./cursor-code-test" 
echo "  ./cursor-coda-server"
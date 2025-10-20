# 🎯 Cursor Code Usage Examples

## Building and Testing the System

### 🔨 Build Everything
```bash
cd cursor-code
./build.sh
```

### 🧪 Run Tests
```bash
# Run via CLI
neko cursor-code.n test

# Or run directly
neko cursor-code-tests.n
```

## Basic Usage Examples

### 📋 Initialize System
```bash
# Initialize with default coda
neko cursor-code.n init

# Initialize with custom coda file
neko cursor-code.n init ../project-euler-coda.yaml
```

### 📊 Check Project Status
```bash
neko cursor-code.n status
```

**Output:**
```
📊 Cursor Code Status Report
==============================
Narrative Form: 0.65

Project Scores:
  ast_fitness: 0.7
  integration: 0.6

💡 Recommendations:
  🟡 Good progress! Focus on optimization
  🔧 Refactor complex functions
  ⚡ Look for performance improvements
```

### 📝 Get Guidance for Sections
```bash
# Get problem analysis guidance
neko cursor-code.n guidance problem_analysis

# Get project-specific recommendations
neko cursor-code.n guidance project_specific

# List all available sections
neko cursor-code.n sections
```

## AI Response Tracking

### 🤖 Track AI Responses
```bash
# Track a response for pattern analysis
neko cursor-code.n track "I will solve this using dynamic programming with memoization."

# Track another response
neko cursor-code.n track "Let me try a graph-based approach with breadth-first search."
```

**Expected Output:**
```
🤖 Tracking AI response...
📊 Response shows significant pattern change
⚠️  Coda update may be needed - check .cursor-update-log.txt
✅ AI response tracked and analyzed
```

### 📋 Check Update Log
```bash
cat .cursor-update-log.txt
```

**Sample Log Output:**
```
🤖 Cursor Code Update Detection Report
=====================================
Timestamp: 1703000000000
Narrative Form: 65%

📊 Recent AI Response Analysis:
- Response diversity suggests new patterns
- AI may be suggesting approaches not in current coda
- Consider updating cursor-coda.yaml with new insights

💌 Dear Cursor, if running via the Cursor app proper, please determine if the cursor-coda.yaml template needs to be updated! Thank you, and have a pleasant tomorrow.

🎯 Suggested Update Areas:
- New problem-solving patterns
- Updated optimization techniques  
- Enhanced debugging strategies
- Project-specific recommendations

📈 Current Project Metrics:
- AST Fitness: 70%
- Integration Score: 60%
- Narrative Form: 65%

=== End Report ===
```

## Web Interface

### 🌐 Start Web Server
```bash
neko cursor-coda-server.n
```

**Access at:** `http://localhost:8080`

**Available Endpoints:**
- `/` - Main dashboard with narrative form
- `/status` - Detailed project status
- `/section/problem_analysis` - Section guidance
- `/api/guidance` - JSON API response

## Integration with Cursor AI

### 📚 Request Guidance
In your Cursor chat, use:
```
"Please read 'cursor coda' about problem_analysis"
"Please read 'cursor coda' about project_specific"
```

### 🔄 Cross-Reference with Updates
When working on problems, the system now prompts to:
1. Cross-reference with cursor-coda.yaml file
2. Update the cursor-coda.yaml with problem analysis where applicable

## Advanced Usage

### 🧪 Run Specific Tests
```bash
# Test front matter parsing
neko cursor-code-tests.n | grep "Front matter"

# Test AI response tracking
neko cursor-code-tests.n | grep "AI response"
```

### 📊 Monitor Narrative Form Changes
```bash
# Update and check narrative form
neko cursor-code.n update
neko cursor-code.n status | grep "Narrative Form"
```

### 🔍 Debug Score Calculations
The system tracks:
- **AST Fitness (60% weight)**: Comment ratio, function density, complexity
- **Integration Score (40% weight)**: Tests, build files, documentation
- **Narrative Form**: Weighted average determining guidance approach

### 📈 Score Interpretation

**Narrative Form Ranges:**
- **0.0 - 0.3 (🔴)**: Focus on fundamentals
- **0.3 - 0.7 (🟡)**: Good progress, optimize
- **0.7 - 1.0 (🟢)**: Excellent, advanced features

**What Each Score Means:**
- **0.0**: Worst possible score
- **1.0**: Best possible score  
- **Scores are weighted averages** of multiple metrics

## File Structure After Usage

```
cursor-code/
├── .cursor-code-state.json      # Persistent state
├── .cursor-update-log.txt       # Update detection log
├── .cursor-code-test-report.json # Test results
├── cursor-code.n               # CLI executable
├── cursor-code-tests.n         # Test executable
├── cursor-coda-server.n        # Web server executable
└── test-frontmatter-temp.yaml  # Temporary test files
```

## Troubleshooting

### 🐛 Common Issues

**Build Fails:**
```bash
# Install missing dependencies
haxelib install yaml
haxelib install hxnodejs
haxelib install sys
```

**No Coda Found:**
```bash
# Create a new coda
neko cursor-code.n create
```

**Tests Fail:**
```bash
# Check file permissions
chmod +x build.sh

# Rebuild everything
./build.sh
```

### 📋 Debug Commands
```bash
# Show available sections
neko cursor-code.n sections

# Force update narrative form
neko cursor-code.n update

# Get guidance for any section
neko cursor-code.n guidance <section_name>
```

## Integration Examples

### With Project Euler
```bash
# Use Project Euler specific coda
neko cursor-code.n init ../project-euler-coda.yaml

# Track mathematical approach
neko cursor-code.n track "I'll use the Sieve of Eratosthenes for prime generation"

# Get mathematical guidance
neko cursor-code.n guidance project_euler_specific
```

### With General Projects
```bash
# Use generic coda
neko cursor-code.n init cursor-coda.yaml

# Get project-specific guidance
neko cursor-code.n guidance project_specific

# Track development approaches
neko cursor-code.n track "Let me refactor this to use dependency injection"
```
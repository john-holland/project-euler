# 🎯 Cursor Code - Mathematical Narrative Guidance System

> *"let narrative_form = 0"*  
> *"as we talk we build scores"*  
> *"judge improvement statically against project yaml and AST's"*  
> *"Use provided haxe toolset for fitness and persistence"*  
> *"Relax scores based on test passing change, and existence of integration"*  
> *"let these scores allow you to narrate without changing anything other than cursor-coda.yaml"*

A standalone Haxe library that provides mathematical scoring and stateless narrative guidance for AI-assisted development.

## 🧮 Mathematical Approach

Cursor Code uses a mathematical scoring system to provide context-aware development guidance:

```haxe
let narrative_form = 0
// as we talk we build scores
// judge improvement statically against project yaml and AST's
// Use provided haxe toolset for fitness and persistence
// Relax scores based on test passing change, and existence of integration
// let these scores allow you to narrate without changing anything other than cursor-coda.yaml
```

### Scoring Components

1. **AST Fitness (60% weight)**
   - Comment ratio analysis
   - Function density measurement
   - Complexity assessment
   - Code structure evaluation

2. **Integration Score (40% weight)**
   - Test file presence
   - Build system integration
   - Documentation coverage
   - Version control status
   - Multi-file project complexity

## 🚀 Quick Start

### Prerequisites
- [Haxe](https://haxe.org/download/) installed
- [Neko](https://nekovm.org/) runtime

### Installation

1. **Install Haxe dependencies:**
```bash
haxelib install yaml
haxelib install hxnodejs
haxelib install haxe-json
```

2. **Build the system:**
```bash
haxe build.hxml
```

3. **Initialize cursor-code:**
```bash
cursor-code init
```

4. **Create your first coda:**
```bash
cursor-code create
```

## 📋 CLI Commands

### Core Commands

```bash
# Initialize the system
cursor-code init

# Create new coda through interactive setup
cursor-code create

# Show current project status and scores
cursor-code status

# Get narrative guidance for a section
cursor-code guidance problem_analysis

# List all available sections
cursor-code sections

# Update narrative form based on current state
cursor-code update
```

### Examples

```bash
# Initialize and create a new coda
cursor-code init
cursor-code create

# Get guidance for algorithm design
cursor-code guidance algorithm_design

# Check project status
cursor-code status
```

## 🌐 Web Interface

Start the web server to view your coda with a beautiful interface:

```bash
cursor-code server
```

Then visit `http://localhost:8080` to see:
- Current narrative form score
- Available sections
- Project status dashboard
- API endpoints

## 📊 Mathematical Scoring

### AST Fitness Calculation

```haxe
// Basic AST fitness metrics
var commentRatio = commentLines / totalLines;
var functionDensity = functionCount / totalLines;
var complexityRatio = complexity / totalLines;

// Weighted fitness calculation
score += commentRatio * 0.2;        // Good documentation
score += functionDensity * 0.3;     // Modular code
score += (1.0 - complexityRatio) * 0.5; // Lower complexity is better
```

### Integration Score Calculation

```haxe
// Integration checks
if (FileSystem.exists("test")) score += 0.3;      // Test files
if (FileSystem.exists("package.json")) score += 0.2; // Node.js project
if (FileSystem.exists("build.hxml")) score += 0.2;   // Build files
if (FileSystem.exists("README.md")) score += 0.1;    // Documentation
if (FileSystem.exists(".git")) score += 0.1;         // Version control
```

### Narrative Form Calculation

```haxe
// Weighted average of AST and Integration scores
narrative_form = (astScore * 0.6) + (integrationScore * 0.4);
```

## 🎯 Usage with Cursor

Once initialized, you can reference specific sections in your development workflow:

```
"Please read 'cursor coda' about problem_analysis"
"Please read 'cursor coda' about algorithm_design"
"Please read 'cursor coda' about optimization_phase"
```

The system will provide context-aware guidance based on your current narrative form score.

## 📁 Project Structure

```
cursor-code/
├── src/
│   ├── CursorCode.hx          # Main library with scoring logic
│   ├── CursorCodeCLI.hx       # Command line interface
│   └── CursorCodaServer.hx    # Web server interface
├── build.hxml                 # Haxe build configuration
├── package.json               # Node.js package configuration
└── README.md                  # This file
```

## 🔧 API Endpoints

### Web API

- `GET /` - Main dashboard
- `GET /status` - Project status report
- `GET /section/{name}` - Section guidance
- `GET /api/guidance` - JSON API response

### JSON Response Format

```json
{
  "narrative_form": 0.75,
  "available_sections": ["problem_analysis", "algorithm_design"],
  "project_scores": {
    "ast_fitness": 0.8,
    "integration": 0.7
  },
  "timestamp": "2024-12-19T10:30:00Z"
}
```

## 🎨 Features

### Mathematical Scoring
- **AST Analysis** - Code structure evaluation
- **Integration Metrics** - Project completeness assessment
- **Persistence** - State saved to `.cursor-code-state.json`
- **Real-time Updates** - Scores update as project evolves

### Narrative Guidance
- **Context-Aware** - Guidance based on current project state
- **Stateless** - No need to modify coda during development
- **Structured** - Organized by development phases
- **Interactive** - CLI and web interfaces

### Development Phases
- **Problem Analysis** - Systematic problem understanding
- **Algorithm Design** - Algorithm design principles
- **Code Quality** - Code quality standards
- **Optimization Strategy** - Performance optimization
- **Debugging Methodology** - Systematic debugging
- **Project Euler Specific** - Domain-specific patterns

## 🔄 State Management

The system automatically manages state through:

1. **Persistence File** - `.cursor-code-state.json`
2. **YAML Configuration** - `cursor-coda.yaml`
3. **Real-time Updates** - Scores recalculated on each command

## 🎯 Benefits

### For Developers
- **Consistency** - Same approach across projects
- **Efficiency** - Quick reference to proven methodologies
- **Quality** - Maintained code quality standards
- **Learning** - Structured approach to problem-solving

### For AI Assistants
- **Context** - Clear understanding of development preferences
- **Guidance** - Structured approach to problem-solving
- **Consistency** - Maintained narrative style and methodology
- **Efficiency** - Reduced need for repeated explanations

## 🚀 Advanced Usage

### Custom Scoring

You can modify the scoring weights in `CursorCode.hx`:

```haxe
// Modify these weights to adjust scoring
narrative_form = (astScore * 0.6) + (integrationScore * 0.4);
```

### Adding New Sections

1. Edit `cursor-coda.yaml`
2. Add new section under `sections:`
3. Include `title`, `preface`, and optional lists
4. Restart the system

### Custom AST Analysis

Extend the `calculateASTFitness` function to add custom metrics:

```haxe
public static function calculateASTFitness(filePath:String):Float {
    // Add your custom AST analysis here
    // Return score between 0.0 and 1.0
}
```

## 🔮 Future Enhancements

### Planned Features
- **Project-specific codas** - Custom sections for different project types
- **Interactive editing** - Web-based YAML editor
- **Version control** - Track changes to development approaches
- **Analytics** - Track which sections are most referenced
- **Export/Import** - Share codas between team members

### Technical Improvements
- **API endpoints** - RESTful API for programmatic access
- **Search functionality** - Find sections by content
- **Tags and categories** - Better organization of sections
- **Markdown support** - Rich text formatting in sections

## 🤝 Contributing

This is an experimental system for improving AI-assisted development. Feel free to:

1. **Fork and modify** - Adapt to your development style
2. **Share your codas** - Contribute sections that work well
3. **Report issues** - Help improve the system
4. **Suggest features** - Help shape the future of the project

## 📄 License

MIT License - Feel free to use and modify as needed.

---

*"The best code is the code that tells a story."* - Cursor Code Philosophy 
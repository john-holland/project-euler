# 🎯 Cursor Coda - Development Narrative System

A structured approach to AI-assisted development that maintains context and consistency across development sessions.

## Overview

Cursor Coda is a YAML-based narrative system that provides structured guidance for AI-assisted development. It allows you to reference specific development methodologies and maintain consistent approaches across different projects and sessions.

## Key Features

### 📝 Stateless Narrative Guidance
- Reference specific development sections with simple commands
- Maintain consistent development approaches
- Avoid context drift during long development sessions

### 🏗️ Structured Development Phases
- **Problem Analysis** - Systematic approach to understanding problems
- **Algorithm Design** - Principles for creating efficient solutions
- **Code Quality** - Standards for maintainable code
- **Optimization Strategy** - Systematic performance improvement
- **Debugging Methodology** - Systematic problem-solving approach
- **Project Euler Specific** - Domain-specific patterns and techniques

### 🎨 Beautiful Web Interface
- Modern, dark-themed UI built with Haxe
- Responsive design for different screen sizes
- Easy navigation between sections

## Usage

### Basic Usage
When working with Cursor, you can reference specific sections:

```
"Please read 'cursor coda' about problem_analysis"
"Please read 'cursor coda' about algorithm_design"
"Please read 'cursor coda' about optimization_phase"
```

### Available Sections
- `problem_analysis` - Systematic problem understanding
- `algorithm_design` - Algorithm design principles
- `code_quality` - Code quality standards
- `optimization_phase` - Performance optimization strategy
- `debugging_strategy` - Systematic debugging approach
- `project_euler_specific` - Domain-specific patterns

## Setup

### Prerequisites
- [Haxe](https://haxe.org/download/) installed
- [Neko](https://nekovm.org/) runtime

### Installation
1. Install Haxe dependencies:
```bash
haxelib install yaml
haxelib install neko
```

2. Build the server:
```bash
haxe build.hxml
```

3. Run the server:
```bash
neko cursor-coda-server.n
```

4. Open your browser to `http://localhost:8080`

## Architecture

### YAML Structure
The system uses a hierarchical YAML structure:

```yaml
cursor_coda:
  sections:
    section_name:
      title: "Section Title"
      preface: "Detailed explanation..."
      key_questions: ["Question 1", "Question 2"]
      development_style: ["Style 1", "Style 2"]
  
  narrative_templates:
    template_type:
      - "Template phrase 1"
      - "Template phrase 2"
  
  context_responses:
    situation:
      - "Response 1"
      - "Response 2"
```

### Web Server
- Built with Haxe and Neko
- Serves static HTML pages
- Parses YAML configuration
- Provides RESTful API for section access

## Customization

### Adding New Sections
1. Edit `cursor-coda.yaml`
2. Add a new section under `sections:`
3. Include `title`, `preface`, and optional lists
4. Restart the server

### Modifying Narrative Templates
1. Edit the `narrative_templates` section
2. Add new template types or modify existing ones
3. Restart the server

### Styling
The web interface uses a dark theme with:
- GitHub-style color scheme
- Monospace fonts for code readability
- Responsive grid layout
- Card-based section display

## Benefits

### For Developers
- **Consistency** - Same approach across different projects
- **Efficiency** - Quick reference to proven methodologies
- **Quality** - Maintained code quality standards
- **Learning** - Structured approach to problem-solving

### For AI Assistants
- **Context** - Clear understanding of development preferences
- **Guidance** - Structured approach to problem-solving
- **Consistency** - Maintained narrative style and methodology
- **Efficiency** - Reduced need for repeated explanations

## Future Enhancements

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

## Contributing

This is an experimental system for improving AI-assisted development. Feel free to:

1. **Fork and modify** - Adapt to your development style
2. **Share your codas** - Contribute sections that work well
3. **Report issues** - Help improve the system
4. **Suggest features** - Help shape the future of the project

## License

MIT License - Feel free to use and modify as needed.

---

*"The best code is the code that tells a story."* - Cursor Coda Philosophy 
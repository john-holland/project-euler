# 🔄 Cursor Code Changes - Front Matter & Project-Specific Updates

## Overview

Updated the Cursor Code system to support YAML front matter and created project-specific guidance sections.

## 🔧 Key Changes

### 1. **Front Matter Support**

The system now supports YAML documents with front matter structure:

```yaml
---
# Front matter sections (direct access)
problem_analysis:
  title: "Problem Analysis Framework"
  preface: |
    Detailed guidance...
  
algorithm_design:
  title: "Algorithm Design Principles"
  preface: |
    More guidance...
---

# Main cursor_coda configuration
cursor_coda:
  version: "1.0"
  project: "Project Name"
  sections:
    project_specific:
      title: "Project Specific Recommendations"
      preface: "project_specific: project specific recommendations..."
```

### 2. **Project-Specific Section**

Updated the `project_specific` section to be more generic:

- **Title**: "Project Specific Recommendations"
- **Preface**: "project_specific: project specific recommendations for helping solve the specific problems of the project"
- **Content**: Generic project-focused guidance instead of Project Euler specifics

### 3. **Project Euler Extraction**

Created `project-euler-coda.yaml` with:
- All Project Euler specific patterns and techniques
- Mathematical problem-solving guidance
- Performance considerations for mathematical problems
- Specialized narrative templates for mathematical work

### 4. **Enhanced Haxe Library**

Updated `CursorCode.hx` with:

```haxe
// New front matter parsing
private static function parseYamlWithFrontMatter(content:String):Dynamic

// Enhanced section lookup (front matter + cursor_coda)
public static function getNarrativeGuidance(section:String):String

// Combined section listing
public static function getAvailableSections():Array<String>
```

### 5. **Web Server Updates**

The web server automatically works with the new structure since it uses the CursorCode library.

## 📁 File Structure

```
cursor-code/
├── src/
│   ├── CursorCode.hx          # Enhanced with front matter support
│   ├── CursorCodeCLI.hx       # CLI interface
│   └── CursorCodaServer.hx    # Web server
├── cursor-coda.yaml           # Updated with front matter
├── project-euler-coda.yaml   # New: Project Euler specific coda
├── test-frontmatter.yaml     # Test file for validation
├── build.sh                  # Build script
└── README.md                 # Documentation
```

## 🚀 Usage Examples

### CLI Commands

```bash
# Build the system
./build.sh

# Initialize
neko cursor-code.n init

# Get guidance from front matter section
neko cursor-code.n guidance problem_analysis

# Get guidance from project_specific section
neko cursor-code.n guidance project_specific

# Start web server
neko cursor-coda-server.n
```

### With Cursor AI

```
"Please read 'cursor coda' about project_specific"
"Please read 'cursor coda' about problem_analysis"
"Please read 'cursor coda' about algorithm_design"
```

## 🔍 Technical Details

### Front Matter Parsing

The system now:
1. Finds YAML front matter delimiters (`---`)
2. Parses front matter as top-level sections
3. Finds and parses the `cursor_coda:` section separately
4. Combines both for section lookup

### Section Priority

When looking up sections:
1. **Front matter sections** (checked first)
2. **cursor_coda.sections** (fallback)

This allows overriding cursor_coda sections with front matter sections.

### Backward Compatibility

The system maintains backward compatibility:
- Works with old YAML format (no front matter)
- Works with new front matter format
- Gracefully handles missing sections

## 🎯 Benefits

### Front Matter Structure
- **Direct Access**: Sections in front matter are directly accessible
- **Cleaner Organization**: Separates content from configuration
- **Flexibility**: Allows project-specific customization at the top level

### Project-Specific Section
- **Generic Guidance**: Works for any project type
- **Contextual**: Adapts to project-specific needs
- **Extensible**: Easy to customize for different domains

### Project Euler Extraction
- **Domain-Specific**: Focused on mathematical problem solving
- **Specialized**: Contains mathematical optimization techniques
- **Reusable**: Can be used across different Project Euler codebases

## 🔮 Future Enhancements

- **Multiple Front Matter Blocks**: Support for complex document structures
- **Template Inheritance**: Allow front matter sections to inherit from cursor_coda sections
- **Dynamic Section Loading**: Load sections from multiple files
- **Section Validation**: Ensure sections have required fields
- **Interactive Front Matter Editor**: Web-based editor for front matter sections
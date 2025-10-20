package;

import haxe.Json;
import yaml.Yaml;
import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;

/**
 * Cursor Code - Mathematical narrative guidance system
 * 
 * let narrative_form = 0
 * //as we talk we build scores
 * // judge improvement statically against project yaml and AST's.
 * // Use provided haxe toolset for fitness and persistance.
 * // Relax scores based on test passing change, and existance of integration.
 * // let these scores allow you to narrate without changing anything other than cursor-coda.yaml
 */
class CursorCode {
    // 0.0 is the worst score, 1.0 is the best score
    // it is a weighted average of the ast_fitness and integration_scores
    // the ast_fitness is a weighted average of the number of comments, functions, and complexity
    // the integration_scores is a weighted average of the number of test files, package.json, build.hxml, and documentation
    // the narrative_form is a weighted average of the ast_fitness and integration_scores
    // the narrative_form is used to determine the narrative form of the project
    public static var narrative_form:Float = 0.0;
    // what are the limmits of the Float in the score maps?
    // 0.0 is the worst score, 1.0 is the best score // may be false, maybe 0 to 100? @cursor, needs testing! yay!
    // it is a weighted average of the ast_fitness and integration_scores
    // the ast_fitness is a weighted average of the number of comments, functions, and complexity
    // the integration_scores is a weighted average of the number of test files, package.json, build.hxml, and documentation
    // the narrative_form is a weighted average of the ast_fitness and integration_scores
    // the narrative_form is used to determine the narrative form of the project
    // project_scores is a map of scores for the project
    public static var project_scores:Map<String, Float> = new Map();
    // ast_fitness is a map of scores for the ast, 0 to 100
    public static var ast_fitness:Map<String, Float> = new Map();
    // integration_scores is a map of scores for the integration, 0 to 100
    public static var integration_scores:Map<String, Float> = new Map();
    
    private static var coda_data:Dynamic;
    private static var project_config:Dynamic;
    private static var aiResponseHistory:Array<String> = [];
    private static var lastAIResponse:String = "";
    private static var responseChangeThreshold:Float = 0.7; // Similarity threshold for detecting significant changes
    
    /**
     * Initialize the Cursor Code system
     */
    public static function init(?configPath:String = "cursor-coda.yaml"):Bool {
        try {
            if (FileSystem.exists(configPath)) {
                var yamlContent = File.getContent(configPath);
                coda_data = parseYamlWithFrontMatter(yamlContent);
                trace("✅ Cursor Code initialized with existing coda");
                return true;
            } else {
                trace("⚠️ No existing coda found, will create new one");
                return false;
            }
        } catch (e:Dynamic) {
            trace('❌ Error initializing Cursor Code: $e');
            return false;
        }
    }
    
    /**
     * Parse YAML with front matter support
     */
    private static function parseYamlWithFrontMatter(content:String):Dynamic {
        var lines = content.split("\n");
        var frontMatterStart = -1;
        var frontMatterEnd = -1;
        var codaStart = -1;
        
        // Find front matter delimiters
        for (i in 0...lines.length) {
            var line = StringTools.trim(lines[i]);
            if (line == "---") {
                if (frontMatterStart == -1) {
                    frontMatterStart = i;
                } else if (frontMatterEnd == -1) {
                    frontMatterEnd = i;
                    break;
                }
            }
        }
        
        // Find cursor_coda section
        for (i in (frontMatterEnd + 1)...lines.length) {
            var line = StringTools.trim(lines[i]);
            if (line.indexOf("cursor_coda:") == 0) {
                codaStart = i;
                break;
            }
        }
        
        var result = {
            frontMatter: {},
            cursor_coda: {}
        };
        
        // Parse front matter
        if (frontMatterStart >= 0 && frontMatterEnd > frontMatterStart) {
            var frontMatterLines = lines.slice(frontMatterStart + 1, frontMatterEnd);
            var frontMatterContent = frontMatterLines.join("\n");
            result.frontMatter = Yaml.parse(frontMatterContent);
        }
        
        // Parse cursor_coda section
        if (codaStart >= 0) {
            var codaLines = lines.slice(codaStart);
            var codaContent = codaLines.join("\n");
            var codaData = Yaml.parse(codaContent);
            result.cursor_coda = codaData.cursor_coda;
        }
        
        return result;
    }
    
    /**
     * Create a new coda through interactive setup
     */
    public static function createNewCoda():Void {
        trace("🎯 Creating new Cursor Coda...");
        
        var sections = [
            "problem_analysis" => "Problem Analysis Framework",
            "algorithm_design" => "Algorithm Design Principles", 
            "code_quality" => "Code Quality Standards",
            "optimization_phase" => "Optimization Strategy",
            "debugging_strategy" => "Debugging Methodology",
            "project_euler_specific" => "Project Euler Specific Patterns"
        ];
        
        var newCoda = {
            cursor_coda: {
                version: "1.0",
                project: "New Project",
                last_updated: Date.now().toString(),
                sections: {},
                narrative_templates: {
                    problem_start: [
                        "Let me analyze this problem systematically",
                        "First, I'll understand the constraints and requirements",
                        "I'll break this down into manageable sub-problems"
                    ],
                    implementation_start: [
                        "Now I'll implement a working solution",
                        "I'll start with a clear, readable approach",
                        "Let me build this step by step"
                    ],
                    optimization_start: [
                        "The solution works, but let me optimize it",
                        "I'll look for mathematical shortcuts first",
                        "Let me analyze the performance bottlenecks"
                    ]
                },
                context_responses: {
                    stuck: [
                        "Let me step back and re-read the problem",
                        "I should try a simpler approach first",
                        "Let me break this down into smaller pieces"
                    ],
                    performance_issue: [
                        "I need to profile this to find bottlenecks",
                        "Let me look for mathematical optimizations",
                        "I should consider a different algorithm"
                    ]
                }
            }
        };
        
        // Interactive section creation
        for (sectionKey => sectionTitle in sections) {
            trace('\n📝 Setting up: $sectionTitle');
            var preface = Sys.stdin().readLine();
            if (preface == null || preface == "") {
                preface = "Default preface for $sectionTitle";
            }
            
            Reflect.setField(newCoda.cursor_coda.sections, sectionKey, {
                title: sectionTitle,
                preface: preface,
                key_questions: [
                    "What are the core concepts?",
                    "What are the constraints?",
                    "What approach should I take?"
                ],
                development_style: [
                    "Start simple and iterate",
                    "Test frequently",
                    "Document decisions"
                ]
            });
        }
        
        // Save the new coda as JSON for now (YAML stringify not available)
        var yamlContent = Json.stringify(newCoda, null, "  ");
        File.saveContent("cursor-coda.yaml", yamlContent);
        coda_data = newCoda;
        
        trace("✅ New Cursor Coda created successfully!");
    }
    
    /**
     * Calculate fitness score based on AST analysis with reflection-based language detection
     */
    public static function calculateASTFitness(filePath:String):Float {
        try {
            if (!FileSystem.exists(filePath)) return 0.0;
            
            var content = File.getContent(filePath);
            var score = 0.0;
            
            // Detect language and get symbols using reflection
            var languageSymbols = detectLanguageSymbols(filePath, content);
            
            // Basic AST fitness metrics
            var lines = content.split("\n");
            var totalLines = lines.length;
            var commentLines = 0;
            var functionCount = 0;
            var classCount = 0;
            var complexity = 0;
            var imports = 0;
            var typeDefinitions = 0;
            
            for (line in lines) {
                var trimmed = StringTools.trim(line);
                
                // Count comments using language-specific patterns
                commentLines += countComments(trimmed, languageSymbols.comments);
                
                // Count functions using language-specific patterns
                functionCount += countFunctions(trimmed, languageSymbols.functions);
                
                // Count classes/types using language-specific patterns
                classCount += countTypes(trimmed, languageSymbols.types);
                
                // Count imports using language-specific patterns
                imports += countImports(trimmed, languageSymbols.imports);
                
                // Calculate complexity using language-specific branching symbols
                complexity += countComplexity(trimmed, languageSymbols.complexity);
                
                // Count type definitions
                typeDefinitions += countTypeDefinitions(trimmed, languageSymbols.typeDefinitions);
            }
            
            // Calculate fitness scores with enhanced metrics
            var commentRatio = commentLines / totalLines;
            var functionDensity = functionCount / totalLines;
            var complexityRatio = complexity / totalLines;
            var importRatio = imports / totalLines;
            var typeRatio = typeDefinitions / totalLines;
            
            // Weighted fitness calculation (enhanced)
            score += commentRatio * 0.15;        // Good documentation
            score += functionDensity * 0.25;     // Modular code
            score += (1.0 - complexityRatio) * 0.35; // Lower complexity is better
            score += importRatio * 0.1;          // Good dependency management
            score += typeRatio * 0.15;           // Strong typing usage
            
            // Language-specific bonuses
            score += calculateLanguageSpecificBonus(languageSymbols, content);
            
            return Math.min(score, 1.0);
            
        } catch (e:Dynamic) {
            trace('❌ Error calculating AST fitness: $e');
            return 0.0;
        }
    }
    
    /**
     * Language symbol definitions using reflection and conditional compilation
     */
    private static function detectLanguageSymbols(filePath:String, content:String):LanguageSymbols {
        var extension = getFileExtension(filePath).toLowerCase();
        var symbols = getBaseSymbols();
        
        // Use reflection to dynamically build language-specific symbol sets
        var symbolRegistry = getSymbolRegistry();
        
        if (Reflect.hasField(symbolRegistry, extension)) {
            var langSymbols = Reflect.field(symbolRegistry, extension);
            
            // Merge language-specific symbols with base symbols
            symbols = mergeSymbols(symbols, langSymbols);
        }
        
        // Additional content-based detection for polyglot files
        symbols = enhanceSymbolsFromContent(symbols, content);
        
        return symbols;
    }
    
    /**
     * Load language symbols from external configuration using reflection
     */
    private static function loadLanguageConfig():Dynamic {
        try {
            if (FileSystem.exists("language-symbols.yaml")) {
                var yamlContent = File.getContent("language-symbols.yaml");
                var config = Yaml.parse(yamlContent);
                return config.languages;
            }
        } catch (e:Dynamic) {
            trace('Warning: Could not load language-symbols.yaml: $e');
        }
        
        // Fallback to built-in registry
        return getBuiltinSymbolRegistry();
    }
    
    /**
     * Get symbol registry using reflection for extensible language support
     */
    private static function getSymbolRegistry():Dynamic {
        // Try to load from external config first, then fallback to built-in
        var externalConfig = loadLanguageConfig();
        if (externalConfig != null) {
            return convertLanguageConfigToRegistry(externalConfig);
        }
        
        return getBuiltinSymbolRegistry();
    }
    
    /**
     * Convert external language config to internal registry format
     */
    private static function convertLanguageConfigToRegistry(languageConfig:Dynamic):Dynamic {
        var registry = {};
        
        for (langName in Reflect.fields(languageConfig)) {
            var langData = Reflect.field(languageConfig, langName);
            
            if (Reflect.hasField(langData, "extensions")) {
                var extensions = Reflect.field(langData, "extensions");
                
                // Map each extension to the language data
                for (ext in (extensions : Array<Dynamic>)) {
                    Reflect.setField(registry, ext, {
                        comments: Reflect.field(langData, "comments") ?? [],
                        functions: Reflect.field(langData, "functions") ?? [],
                        types: Reflect.field(langData, "types") ?? [],
                        imports: Reflect.field(langData, "imports") ?? [],
                        complexity: Reflect.field(langData, "complexity") ?? [],
                        typeDefinitions: Reflect.field(langData, "typeDefinitions") ?? []
                    });
                }
            }
        }
        
        return registry;
    }
    
    /**
     * Built-in symbol registry (fallback)
     */
    private static function getBuiltinSymbolRegistry():Dynamic {
        return {
            // JavaScript/TypeScript
            "js": {
                comments: ["//", "/*", "*/", "/**"],
                functions: ["function", "=>", "async function", "function*"],
                types: ["class", "interface", "type", "enum"],
                imports: ["import", "require", "from"],
                complexity: ["if", "else", "for", "while", "switch", "case", "try", "catch", "?", "&&", "||"],
                typeDefinitions: [":", "as", "typeof", "keyof", "extends", "implements"]
            },
            
            "ts": {
                comments: ["//", "/*", "*/", "/**"],
                functions: ["function", "=>", "async function", "function*", "abstract"],
                types: ["class", "interface", "type", "enum", "namespace", "module"],
                imports: ["import", "export", "from", "require"],
                complexity: ["if", "else", "for", "while", "switch", "case", "try", "catch", "?", "&&", "||", "??"],
                typeDefinitions: [":", "as", "typeof", "keyof", "extends", "implements", "<", ">"]
            },
            
            // Haxe
            "hx": {
                comments: ["//", "/*", "*/", "/**"],
                functions: ["function", "->", "static function", "inline function", "macro"],
                types: ["class", "interface", "enum", "abstract", "typedef"],
                imports: ["import", "using", "from"],
                complexity: ["if", "else", "for", "while", "switch", "case", "try", "catch", "?", "&&", "||"],
                typeDefinitions: [":", "->", "extends", "implements", "<", ">", "typedef"]
            },
            
            // Python
            "py": {
                comments: ["#", '"""', "'''"],
                functions: ["def", "lambda", "async def"],
                types: ["class", "dataclass", "Protocol", "TypedDict"],
                imports: ["import", "from", "as"],
                complexity: ["if", "elif", "else", "for", "while", "try", "except", "match", "case", "and", "or"],
                typeDefinitions: [":", "->", "Union", "Optional", "List", "Dict", "Tuple"]
            },
            
            // Rust
            "rs": {
                comments: ["//", "/*", "*/", "///", "//!"],
                functions: ["fn", "async fn", "const fn", "unsafe fn"],
                types: ["struct", "enum", "trait", "impl", "type"],
                imports: ["use", "mod", "extern", "crate"],
                complexity: ["if", "else", "for", "while", "loop", "match", "?", "&&", "||"],
                typeDefinitions: [":", "->", "impl", "where", "<", ">", "dyn"]
            },
            
            // Go
            "go": {
                comments: ["//", "/*", "*/"],
                functions: ["func", "go func"],
                types: ["type", "struct", "interface"],
                imports: ["import", "package"],
                complexity: ["if", "else", "for", "switch", "case", "select", "go", "defer", "&&", "||"],
                typeDefinitions: ["type", "struct", "interface", "chan", "map"]
            },
            
            // C/C++
            "c": {
                comments: ["//", "/*", "*/"],
                functions: ["int", "void", "char", "float", "double", "static", "inline"],
                types: ["struct", "union", "enum", "typedef"],
                imports: ["#include", "#import"],
                complexity: ["if", "else", "for", "while", "switch", "case", "?", "&&", "||"],
                typeDefinitions: ["typedef", "struct", "union", "enum", "*", "const"]
            },
            
            "cpp": {
                comments: ["//", "/*", "*/"],
                functions: ["int", "void", "auto", "template", "virtual", "static", "inline", "constexpr"],
                types: ["class", "struct", "union", "enum", "template", "namespace"],
                imports: ["#include", "#import", "using", "namespace"],
                complexity: ["if", "else", "for", "while", "switch", "case", "try", "catch", "?", "&&", "||"],
                typeDefinitions: ["typedef", "using", "template", "<", ">", "::", "const", "auto"]
            }
        };
    }
    
    /**
     * Platform-specific string operations using conditional compilation
     */
    #if (js || nodejs)
    private static function stringStartsWith(str:String, prefix:String):Bool {
        return str.indexOf(prefix) == 0;
    }
    
    private static function stringEndsWith(str:String, suffix:String):Bool {
        return str.endsWith(suffix);
    }
    #else
    private static function stringStartsWith(str:String, prefix:String):Bool {
        return str.indexOf(prefix) == 0;
    }
    
    private static function stringEndsWith(str:String, suffix:String):Bool {
        return str.lastIndexOf(suffix) == (str.length - suffix.length);
    }
    #end
    
    /**
     * Enhanced symbol counting functions
     */
    private static function countComments(line:String, commentSymbols:Array<String>):Int {
        var count = 0;
        for (symbol in commentSymbols) {
            if (line.indexOf(symbol) >= 0) {
                count++;
                break; // Count only once per line
            }
        }
        return count;
    }
    
    private static function countFunctions(line:String, functionSymbols:Array<String>):Int {
        var count = 0;
        for (symbol in functionSymbols) {
            if (line.indexOf(symbol) >= 0) {
                count++;
                break; // Count only once per line
            }
        }
        return count;
    }
    
    private static function countTypes(line:String, typeSymbols:Array<String>):Int {
        var count = 0;
        for (symbol in typeSymbols) {
            if (line.indexOf(symbol) >= 0) {
                count++;
                break; // Count only once per line
            }
        }
        return count;
    }
    
    private static function countImports(line:String, importSymbols:Array<String>):Int {
        var count = 0;
        for (symbol in importSymbols) {
            if (stringStartsWith(StringTools.trim(line), symbol)) {
                count++;
                break; // Count only once per line
            }
        }
        return count;
    }
    
    private static function countComplexity(line:String, complexitySymbols:Array<String>):Int {
        var count = 0;
        for (symbol in complexitySymbols) {
            // Count each occurrence for complexity analysis
            var index = 0;
            while ((index = line.indexOf(symbol, index)) >= 0) {
                count++;
                index += symbol.length;
            }
        }
        return count;
    }
    
    private static function countTypeDefinitions(line:String, typeDefSymbols:Array<String>):Int {
        var count = 0;
        for (symbol in typeDefSymbols) {
            if (line.indexOf(symbol) >= 0) {
                count++;
                break; // Count only once per line
            }
        }
        return count;
    }
    
    /**
     * Language-specific bonus calculations
     */
    private static function calculateLanguageSpecificBonus(symbols:LanguageSymbols, content:String):Float {
        var bonus = 0.0;
        
        // Functional programming patterns bonus
        if (content.indexOf("=>") >= 0 || content.indexOf("map") >= 0 || content.indexOf("filter") >= 0) {
            bonus += 0.05;
        }
        
        // Type safety bonus (strong typing)
        if (symbols.typeDefinitions.length > 5) {
            bonus += 0.05;
        }
        
        // Modern syntax bonus
        if (content.indexOf("const") >= 0 || content.indexOf("let") >= 0 || content.indexOf("async") >= 0) {
            bonus += 0.03;
        }
        
        // Documentation bonus (JSDoc, etc.)
        if (content.indexOf("/**") >= 0 || content.indexOf("@param") >= 0 || content.indexOf("@return") >= 0) {
            bonus += 0.07;
        }
        
        return Math.min(bonus, 0.2); // Cap bonus at 20%
    }
    
    /**
     * Helper functions
     */
    private static function getFileExtension(filePath:String):String {
        var lastDot = filePath.lastIndexOf(".");
        return lastDot >= 0 ? filePath.substring(lastDot + 1) : "";
    }
    
    private static function getBaseSymbols():LanguageSymbols {
        return {
            comments: ["//", "/*"],
            functions: ["function"],
            types: ["class"],
            imports: ["import"],
            complexity: ["if", "for", "while"],
            typeDefinitions: [":"]
        };
    }
    
    private static function mergeSymbols(base:LanguageSymbols, specific:Dynamic):LanguageSymbols {
        return {
            comments: Reflect.hasField(specific, "comments") ? Reflect.field(specific, "comments") : base.comments,
            functions: Reflect.hasField(specific, "functions") ? Reflect.field(specific, "functions") : base.functions,
            types: Reflect.hasField(specific, "types") ? Reflect.field(specific, "types") : base.types,
            imports: Reflect.hasField(specific, "imports") ? Reflect.field(specific, "imports") : base.imports,
            complexity: Reflect.hasField(specific, "complexity") ? Reflect.field(specific, "complexity") : base.complexity,
            typeDefinitions: Reflect.hasField(specific, "typeDefinitions") ? Reflect.field(specific, "typeDefinitions") : base.typeDefinitions
        };
    }
    
    private static function enhanceSymbolsFromContent(symbols:LanguageSymbols, content:String):LanguageSymbols {
        // Detect additional patterns from content analysis
        
        // JSX/React patterns
        if (content.indexOf("jsx") >= 0 || content.indexOf("React") >= 0 || content.indexOf("<") >= 0) {
            symbols.complexity = symbols.complexity.concat(["&&", "||", "?", ":"]);
            symbols.functions = symbols.functions.concat(["useEffect", "useState", "Component"]);
        }
        
        // Async patterns
        if (content.indexOf("async") >= 0 || content.indexOf("await") >= 0 || content.indexOf("Promise") >= 0) {
            symbols.complexity = symbols.complexity.concat(["await", "then", "catch"]);
            symbols.functions = symbols.functions.concat(["async", "Promise"]);
        }
        
        return symbols;
    }
    
    /**
     * Analyze build system and configuration files using reflection
     */
    public static function analyzeBuildSystemFitness(projectPath:String):Float {
        try {
            var buildSystemScore = 0.0;
            var foundFiles = 0;
            
            // Get build system registry using reflection
            var buildSystemRegistry = getBuildSystemRegistry();
            
            for (fileName in Reflect.fields(buildSystemRegistry)) {
                var filePath = Path.join([projectPath, fileName]);
                
                if (FileSystem.exists(filePath)) {
                    foundFiles++;
                    var analyzer = Reflect.field(buildSystemRegistry, fileName);
                    var fileScore = analyzeBuildSystemFile(filePath, analyzer);
                    buildSystemScore += fileScore;
                    
                    trace('📦 Analyzed $fileName: ${Math.round(fileScore * 100)}%');
                }
            }
            
            // Average score across found files
            return foundFiles > 0 ? buildSystemScore / foundFiles : 0.0;
            
        } catch (e:Dynamic) {
            trace('❌ Error analyzing build system: $e');
            return 0.0;
        }
    }
    
    /**
     * Build system registry using reflection for extensible support
     */
    private static function getBuildSystemRegistry():Dynamic {
        return {
            // Node.js/JavaScript ecosystem
            "package.json": {
                type: "json",
                ecosystem: "nodejs",
                analyzer: analyzePackageJson,
                weights: {
                    dependencies: 0.25,
                    scripts: 0.20,
                    metadata: 0.15,
                    security: 0.25,
                    quality: 0.15
                }
            },
            
            "package-lock.json": {
                type: "json", 
                ecosystem: "nodejs",
                analyzer: analyzePackageLock,
                weights: { lockfile: 0.8, integrity: 0.2 }
            },
            
            "yarn.lock": {
                type: "text",
                ecosystem: "nodejs", 
                analyzer: analyzeYarnLock,
                weights: { lockfile: 0.8, integrity: 0.2 }
            },
            
            // Python ecosystem
            "pyproject.toml": {
                type: "toml",
                ecosystem: "python",
                analyzer: analyzePyProjectToml,
                weights: {
                    dependencies: 0.3,
                    build_system: 0.25,
                    metadata: 0.2,
                    tools: 0.25
                }
            },
            
            "requirements.txt": {
                type: "text",
                ecosystem: "python",
                analyzer: analyzeRequirementsTxt,
                weights: { dependencies: 0.8, pinning: 0.2 }
            },
            
            "Pipfile": {
                type: "toml",
                ecosystem: "python",
                analyzer: analyzePipfile,
                weights: { dependencies: 0.6, dev_dependencies: 0.4 }
            },
            
            "setup.py": {
                type: "python",
                ecosystem: "python", 
                analyzer: analyzeSetupPy,
                weights: { setup: 0.7, metadata: 0.3 }
            },
            
            // Rust ecosystem
            "Cargo.toml": {
                type: "toml",
                ecosystem: "rust",
                analyzer: analyzeCargoToml,
                weights: {
                    dependencies: 0.3,
                    metadata: 0.2,
                    features: 0.2,
                    workspace: 0.3
                }
            },
            
            "Cargo.lock": {
                type: "toml",
                ecosystem: "rust",
                analyzer: analyzeCargoLock,
                weights: { lockfile: 0.9, resolution: 0.1 }
            },
            
            // Go ecosystem
            "go.mod": {
                type: "text",
                ecosystem: "go",
                analyzer: analyzeGoMod,
                weights: { module: 0.4, dependencies: 0.6 }
            },
            
            "go.sum": {
                type: "text",
                ecosystem: "go",
                analyzer: analyzeGoSum,
                weights: { checksums: 1.0 }
            },
            
            // Java/Kotlin ecosystem
            "build.gradle": {
                type: "gradle",
                ecosystem: "jvm",
                analyzer: analyzeBuildGradle,
                weights: {
                    dependencies: 0.3,
                    plugins: 0.25,
                    tasks: 0.25,
                    configuration: 0.2
                }
            },
            
            "build.gradle.kts": {
                type: "kotlin",
                ecosystem: "jvm",
                analyzer: analyzeBuildGradleKts,
                weights: {
                    dependencies: 0.3,
                    plugins: 0.25,
                    tasks: 0.25,
                    configuration: 0.2
                }
            },
            
            "pom.xml": {
                type: "xml",
                ecosystem: "jvm",
                analyzer: analyzePomXml,
                weights: {
                    dependencies: 0.4,
                    plugins: 0.3,
                    metadata: 0.3
                }
            },
            
            // Swift ecosystem
            "Package.swift": {
                type: "swift",
                ecosystem: "swift",
                analyzer: analyzePackageSwift,
                weights: {
                    dependencies: 0.5,
                    targets: 0.3,
                    platforms: 0.2
                }
            },
            
            // Ruby ecosystem  
            "Gemfile": {
                type: "ruby",
                ecosystem: "ruby",
                analyzer: analyzeGemfile,
                weights: { dependencies: 0.7, groups: 0.3 }
            },
            
            "Gemfile.lock": {
                type: "text",
                ecosystem: "ruby",
                analyzer: analyzeGemfileLock,
                weights: { lockfile: 1.0 }
            },
            
            // PHP ecosystem
            "composer.json": {
                type: "json",
                ecosystem: "php",
                analyzer: analyzeComposerJson,
                weights: {
                    dependencies: 0.4,
                    autoload: 0.3,
                    scripts: 0.3
                }
            },
            
            // .NET ecosystem
            "*.csproj": {
                type: "xml",
                ecosystem: "dotnet",
                analyzer: analyzeCsproj,
                weights: {
                    packageReferences: 0.5,
                    targetFramework: 0.3,
                    properties: 0.2
                }
            },
            
            // Haxe ecosystem
            "build.hxml": {
                type: "hxml",
                ecosystem: "haxe",
                analyzer: analyzeHxml,
                weights: {
                    targets: 0.4,
                    libraries: 0.3,
                    classpath: 0.3
                }
            },
            
            "haxelib.json": {
                type: "json",
                ecosystem: "haxe",
                analyzer: analyzeHaxelibJson,
                weights: {
                    dependencies: 0.5,
                    metadata: 0.5
                }
            }
        };
    }
    
    /**
     * Analyze individual build system file using reflection
     */
    private static function analyzeBuildSystemFile(filePath:String, analyzer:Dynamic):Float {
        try {
            var content = File.getContent(filePath);
            var analysisType = Reflect.field(analyzer, "type");
            var ecosystem = Reflect.field(analyzer, "ecosystem");
            var weights = Reflect.field(analyzer, "weights");
            
            // Use reflection to call appropriate analyzer function
            var analyzerFunc = Reflect.field(analyzer, "analyzer");
            
            if (analyzerFunc != null && Reflect.isFunction(analyzerFunc)) {
                return Reflect.callMethod(null, analyzerFunc, [content, weights]);
            } else {
                // Fallback generic analysis
                return analyzeGenericBuildFile(content, analysisType, weights);
            }
            
        } catch (e:Dynamic) {
            trace('❌ Error analyzing build file $filePath: $e');
            return 0.0;
        }
    }
    
    /**
     * Package.json analyzer using reflection for dependency analysis
     */
    private static function analyzePackageJson(content:String, weights:Dynamic):Float {
        try {
            var packageData = Json.parse(content);
            var score = 0.0;
            
            // Dependency analysis using reflection
            var depScore = analyzeDependencies(packageData, ["dependencies", "devDependencies", "peerDependencies", "optionalDependencies"]);
            score += depScore * Reflect.field(weights, "dependencies");
            
            // Scripts analysis
            var scriptScore = analyzePackageScripts(packageData);
            score += scriptScore * Reflect.field(weights, "scripts");
            
            // Metadata quality
            var metaScore = analyzePackageMetadata(packageData);
            score += metaScore * Reflect.field(weights, "metadata");
            
            // Security and quality checks
            var securityScore = analyzePackageSecurity(packageData);
            score += securityScore * Reflect.field(weights, "security");
            
            var qualityScore = analyzePackageQuality(packageData);
            score += qualityScore * Reflect.field(weights, "quality");
            
            return Math.min(score, 1.0);
            
        } catch (e:Dynamic) {
            trace('❌ Error parsing package.json: $e');
            return 0.0;
        }
    }
    
    /**
     * Dependency analysis using reflection for multiple dependency types
     */
    private static function analyzeDependencies(packageData:Dynamic, depTypes:Array<String>):Float {
        var totalDeps = 0;
        var pinnedDeps = 0;
        var outdatedPatterns = 0;
        var securePatterns = 0;
        
        for (depType in depTypes) {
            if (Reflect.hasField(packageData, depType)) {
                var deps = Reflect.field(packageData, depType);
                
                for (depName in Reflect.fields(deps)) {
                    totalDeps++;
                    var version = Reflect.field(deps, depName);
                    
                    // Analyze version patterns using reflection
                    var versionAnalysis = analyzeVersionPattern(version);
                    
                    if (versionAnalysis.isPinned) pinnedDeps++;
                    if (versionAnalysis.isOutdated) outdatedPatterns++;
                    if (versionAnalysis.isSecure) securePatterns++;
                }
            }
        }
        
        if (totalDeps == 0) return 0.5; // Neutral score for no dependencies
        
        var pinnedRatio = pinnedDeps / totalDeps;
        var secureRatio = securePatterns / totalDeps;
        var freshRatio = 1.0 - (outdatedPatterns / totalDeps);
        
        return (pinnedRatio * 0.3 + secureRatio * 0.4 + freshRatio * 0.3);
    }
    
    /**
     * Version pattern analysis using reflection
     */
    private static function analyzeVersionPattern(version:String):Dynamic {
        var patterns = getVersionPatterns();
        var analysis = {
            isPinned: false,
            isOutdated: false,
            isSecure: true,
            riskLevel: 0.0
        };
        
        // Use reflection to analyze version patterns
        for (patternName in Reflect.fields(patterns)) {
            var pattern = Reflect.field(patterns, patternName);
            var regex = new EReg(Reflect.field(pattern, "regex"), "g");
            
            if (regex.match(version)) {
                analysis.isPinned = Reflect.field(pattern, "isPinned");
                analysis.riskLevel = Reflect.field(pattern, "riskLevel");
                analysis.isSecure = Reflect.field(pattern, "isSecure");
                break;
            }
        }
        
        return analysis;
    }
    
    /**
     * Version pattern registry using reflection
     */
    private static function getVersionPatterns():Dynamic {
        return {
            "exact": {
                regex: "^[0-9]+\\.[0-9]+\\.[0-9]+$",
                isPinned: true,
                riskLevel: 0.1,
                isSecure: true
            },
            "caret": {
                regex: "^\\^[0-9]+\\.[0-9]+\\.[0-9]+",
                isPinned: false,
                riskLevel: 0.3,
                isSecure: true
            },
            "tilde": {
                regex: "^~[0-9]+\\.[0-9]+\\.[0-9]+",
                isPinned: false,
                riskLevel: 0.2,
                isSecure: true
            },
            "wildcard": {
                regex: "\\*",
                isPinned: false,
                riskLevel: 0.8,
                isSecure: false
            },
            "latest": {
                regex: "latest",
                isPinned: false,
                riskLevel: 0.9,
                isSecure: false
            },
            "git": {
                regex: "git\\+",
                isPinned: false,
                riskLevel: 0.7,
                isSecure: false
            }
        };
    }
    
    /**
     * Package scripts analysis
     */
    private static function analyzePackageScripts(packageData:Dynamic):Float {
        if (!Reflect.hasField(packageData, "scripts")) return 0.3;
        
        var scripts = Reflect.field(packageData, "scripts");
        var scriptFields = Reflect.fields(scripts);
        var score = 0.0;
        
        // Essential scripts check using reflection
        var essentialScripts = ["test", "build", "start", "lint"];
        var foundEssential = 0;
        
        for (essential in essentialScripts) {
            if (scriptFields.indexOf(essential) >= 0) {
                foundEssential++;
            }
        }
        
        score += (foundEssential / essentialScripts.length) * 0.6;
        
        // Script complexity and quality
        var complexScripts = 0;
        for (scriptName in scriptFields) {
            var scriptContent = Reflect.field(scripts, scriptName);
            if (analyzeScriptComplexity(scriptContent) > 0.5) {
                complexScripts++;
            }
        }
        
        if (scriptFields.length > 0) {
            score += (complexScripts / scriptFields.length) * 0.4;
        }
        
        return Math.min(score, 1.0);
    }
    
    /**
     * Script complexity analysis
     */
    private static function analyzeScriptComplexity(script:String):Float {
        var complexity = 0.0;
        
        // Command chaining
        if (script.indexOf("&&") >= 0) complexity += 0.2;
        if (script.indexOf("||") >= 0) complexity += 0.2;
        if (script.indexOf("|") >= 0) complexity += 0.1;
        
        // Tool usage
        if (script.indexOf("webpack") >= 0) complexity += 0.3;
        if (script.indexOf("babel") >= 0) complexity += 0.2;
        if (script.indexOf("eslint") >= 0) complexity += 0.2;
        if (script.indexOf("jest") >= 0) complexity += 0.2;
        
        return Math.min(complexity, 1.0);
    }
    
    /**
     * Package metadata analysis
     */
    private static function analyzePackageMetadata(packageData:Dynamic):Float {
        var score = 0.0;
        var checks = 0;
        
        // Essential metadata fields
        var metadataFields = ["name", "version", "description", "author", "license", "repository", "keywords"];
        
        for (field in metadataFields) {
            checks++;
            if (Reflect.hasField(packageData, field)) {
                var value = Reflect.field(packageData, field);
                if (value != null && value != "") {
                    score += 1.0;
                }
            }
        }
        
        return checks > 0 ? score / checks : 0.0;
    }
    
    /**
     * Package security analysis
     */
    private static function analyzePackageSecurity(packageData:Dynamic):Float {
        var score = 1.0; // Start with perfect security score
        
        // Check for known insecure patterns
        if (Reflect.hasField(packageData, "scripts")) {
            var scripts = Reflect.field(packageData, "scripts");
            
            for (scriptName in Reflect.fields(scripts)) {
                var script = Reflect.field(scripts, scriptName);
                
                // Security red flags
                if (script.indexOf("curl") >= 0 && script.indexOf("bash") >= 0) score -= 0.3;
                if (script.indexOf("wget") >= 0 && script.indexOf("sh") >= 0) score -= 0.3;
                if (script.indexOf("eval") >= 0) score -= 0.2;
                if (script.indexOf("rm -rf") >= 0) score -= 0.1;
            }
        }
        
        return Math.max(score, 0.0);
    }
    
    /**
     * Package quality analysis
     */
    private static function analyzePackageQuality(packageData:Dynamic):Float {
        var score = 0.0;
        
        // Quality indicators
        if (Reflect.hasField(packageData, "engines")) score += 0.2;
        if (Reflect.hasField(packageData, "files")) score += 0.2;
        if (Reflect.hasField(packageData, "main")) score += 0.2;
        if (Reflect.hasField(packageData, "types")) score += 0.2;
        if (Reflect.hasField(packageData, "exports")) score += 0.2;
        
        return Math.min(score, 1.0);
    }
    
    /**
     * Package-lock.json analyzer
     */
    private static function analyzePackageLock(content:String, weights:Dynamic):Float {
        try {
            var lockData = Json.parse(content);
            var score = 0.0;
            
            // Check for lockfileVersion
            if (Reflect.hasField(lockData, "lockfileVersion")) {
                score += 0.5;
            }
            
            // Check for dependencies
            if (Reflect.hasField(lockData, "dependencies")) {
                score += 0.3;
            }
            
            // Check for integrity hashes
            if (Reflect.hasField(lockData, "packages")) {
                score += 0.2;
            }
            
            return Math.min(score, 1.0);
        } catch (e:Dynamic) {
            return 0.5; // Neutral score if parsing fails
        }
    }
    
    /**
     * Yarn.lock analyzer
     */
    private static function analyzeYarnLock(content:String, weights:Dynamic):Float {
        // Simple heuristic analysis for yarn.lock
        var score = 0.0;
        
        if (content.indexOf("yarn lockfile") >= 0) score += 0.3;
        if (content.indexOf("integrity") >= 0) score += 0.4;
        if (content.indexOf("resolved") >= 0) score += 0.3;
        
        return Math.min(score, 1.0);
    }
    
    /**
     * Other build system analyzers (stubs for now)
     */
    private static function analyzePyProjectToml(content:String, weights:Dynamic):Float {
        return 0.7; // Placeholder
    }
    
    private static function analyzeRequirementsTxt(content:String, weights:Dynamic):Float {
        return 0.6; // Placeholder
    }
    
    private static function analyzePipfile(content:String, weights:Dynamic):Float {
        return 0.7; // Placeholder
    }
    
    private static function analyzeSetupPy(content:String, weights:Dynamic):Float {
        return 0.5; // Placeholder
    }
    
    private static function analyzeCargoToml(content:String, weights:Dynamic):Float {
        return 0.8; // Placeholder
    }
    
    private static function analyzeCargoLock(content:String, weights:Dynamic):Float {
        return 0.7; // Placeholder
    }
    
    private static function analyzeGoMod(content:String, weights:Dynamic):Float {
        return 0.7; // Placeholder
    }
    
    private static function analyzeGoSum(content:String, weights:Dynamic):Float {
        return 0.8; // Placeholder
    }
    
    private static function analyzeBuildGradle(content:String, weights:Dynamic):Float {
        return 0.7; // Placeholder
    }
    
    private static function analyzeBuildGradleKts(content:String, weights:Dynamic):Float {
        return 0.8; // Placeholder
    }
    
    private static function analyzePomXml(content:String, weights:Dynamic):Float {
        return 0.6; // Placeholder
    }
    
    private static function analyzePackageSwift(content:String, weights:Dynamic):Float {
        return 0.7; // Placeholder
    }
    
    private static function analyzeGemfile(content:String, weights:Dynamic):Float {
        return 0.6; // Placeholder
    }
    
    private static function analyzeGemfileLock(content:String, weights:Dynamic):Float {
        return 0.7; // Placeholder
    }
    
    private static function analyzeComposerJson(content:String, weights:Dynamic):Float {
        return 0.6; // Placeholder
    }
    
    private static function analyzeCsproj(content:String, weights:Dynamic):Float {
        return 0.6; // Placeholder
    }
    
    private static function analyzeHxml(content:String, weights:Dynamic):Float {
        return 0.8; // Placeholder
    }
    
    private static function analyzeHaxelibJson(content:String, weights:Dynamic):Float {
        return 0.7; // Placeholder
    }

    /**
     * Generic build file analyzer for unknown formats
     */
    private static function analyzeGenericBuildFile(content:String, fileType:String, weights:Dynamic):Float {
        var score = 0.0;
        var lines = content.split("\n");
        
        // Basic complexity analysis
        var configLines = 0;
        var commentLines = 0;
        
        for (line in lines) {
            var trimmed = StringTools.trim(line);
            
            if (trimmed.length == 0) continue;
            
            // Count comments (basic patterns)
            if (trimmed.indexOf("#") == 0 || trimmed.indexOf("//") == 0 || trimmed.indexOf("/*") == 0) {
                commentLines++;
            } else {
                configLines++;
            }
        }
        
        // Basic scoring
        if (configLines > 0) {
            var commentRatio = commentLines / (configLines + commentLines);
            score = 0.5 + (commentRatio * 0.5); // Base score + comment bonus
        }
        
        return Math.min(score, 1.0);
    }
    
    /**
     * Calculate integration score based on test passing
     */
    public static function calculateIntegrationScore():Float {
        var score = 0.0;
        
        // Check for test files
        if (FileSystem.exists("test")) {
            score += 0.3;
        }
        
        // Check for package.json (Node.js project)
        if (FileSystem.exists("package.json")) {
            score += 0.2;
        }
        
        // Check for build configuration
        if (FileSystem.exists("build.hxml") || FileSystem.exists("Makefile")) {
            score += 0.2;
        }
        
        // Check for documentation
        if (FileSystem.exists("README.md") || FileSystem.exists("docs")) {
            score += 0.3;
        }
        
        return Math.min(score, 1.0);
    }
    
    /**
     * Update narrative form based on current project state
     */
    public static function updateNarrativeForm():Void {
        var oldForm = narrative_form;
        
        // Calculate new narrative form based on scores
        var astScore = 0.0;
        var integrationScore = calculateIntegrationScore();
        
        // Calculate average AST fitness across all source files
        var totalASTScore = 0.0;
        var fileCount = 0;
        
        if (FileSystem.exists("src")) {
            for (file in FileSystem.readDirectory("src")) {
                if (file.indexOf(".hx") >= 0 || file.indexOf(".js") >= 0 || file.indexOf(".ts") >= 0) {
                    var fitness = calculateASTFitness('src/$file');
                    totalASTScore += fitness;
                    fileCount++;
                }
            }
        }
        
        if (fileCount > 0) {
            astScore = totalASTScore / fileCount;
        }
        
        // Update project scores
        project_scores.set("ast_fitness", astScore);
        project_scores.set("integration", integrationScore);
        
        // Calculate narrative form (weighted average)
        narrative_form = (astScore * 0.6) + (integrationScore * 0.4);
        
        trace('📊 Narrative Form: ${Math.round(narrative_form * 100)}% (AST: ${Math.round(astScore * 100)}%, Integration: ${Math.round(integrationScore * 100)}%)');
        
        if (narrative_form > oldForm) {
            trace("📈 Project fitness improved!");
        } else if (narrative_form < oldForm) {
            trace("📉 Project fitness declined");
        }
    }
    
    /**
     * Get narrative guidance based on current state
     */
    public static function getNarrativeGuidance(section:String):String {
        if (coda_data == null) {
            return "❌ Cursor Code not initialized. Run 'cursor-code init' first.";
        }
        
        var sectionData = null;
        
        // Try to find section in front matter first
        if (Reflect.hasField(coda_data, "frontMatter") && Reflect.field(coda_data.frontMatter, section) != null) {
            sectionData = Reflect.field(coda_data.frontMatter, section);
        }
        // Then try cursor_coda sections
        else if (Reflect.hasField(coda_data, "cursor_coda") && 
                 Reflect.hasField(coda_data.cursor_coda, "sections") &&
                 Reflect.field(coda_data.cursor_coda.sections, section) != null) {
            sectionData = Reflect.field(coda_data.cursor_coda.sections, section);
        }
        
        if (sectionData == null) {
            return '❌ Section "$section" not found in coda.';
        }
        
        var guidance = '📝 ${sectionData.title}\n\n';
        guidance += '${sectionData.preface}\n\n';
        
        // Add context-aware guidance based on narrative form
        if (narrative_form < 0.3) {
            guidance += "🔴 Current project state suggests focusing on fundamentals.\n";
            guidance += "Consider: Starting with simple, working solutions\n";
        } else if (narrative_form < 0.7) {
            guidance += "🟡 Project is progressing well. Focus on optimization.\n";
            guidance += "Consider: Refactoring and performance improvements\n";
        } else {
            guidance += "🟢 Project is in excellent shape. Focus on advanced features.\n";
            guidance += "Consider: Complex optimizations and edge cases\n";
        }
        
        return guidance;
    }
    
    /**
     * Get all available sections
     */
    public static function getAvailableSections():Array<String> {
        if (coda_data == null) return [];
        
        var sections = [];
        
        // Add sections from front matter
        if (Reflect.hasField(coda_data, "frontMatter")) {
            for (sectionName in Reflect.fields(coda_data.frontMatter)) {
                var sectionData = Reflect.field(coda_data.frontMatter, sectionName);
                // Check if it's a section (has title and preface)
                if (Reflect.hasField(sectionData, "title") && Reflect.hasField(sectionData, "preface")) {
                    sections.push(sectionName);
                }
            }
        }
        
        // Add sections from cursor_coda
        if (Reflect.hasField(coda_data, "cursor_coda") && 
            Reflect.hasField(coda_data.cursor_coda, "sections")) {
            for (sectionName in Reflect.fields(coda_data.cursor_coda.sections)) {
                if (sections.indexOf(sectionName) == -1) { // Avoid duplicates
                    sections.push(sectionName);
                }
            }
        }
        
        return sections;
    }
    
    /**
     * Save current state to persistence file
     */
    public static function saveState():Void {
        var state = {
            narrative_form: narrative_form,
            project_scores: project_scores,
            ast_fitness: ast_fitness,
            integration_scores: integration_scores,
            aiResponseHistory: aiResponseHistory,
            lastAIResponse: lastAIResponse,
            timestamp: Date.now().toString()
        };
        
        var jsonContent = Json.stringify(state, null, "  ");
        File.saveContent(".cursor-code-state.json", jsonContent);
        trace("💾 Cursor Code state saved");
    }
    
    /**
     * Load state from persistence file
     */
    public static function loadState():Void {
        if (FileSystem.exists(".cursor-code-state.json")) {
            try {
                var jsonContent = File.getContent(".cursor-code-state.json");
                var state = Json.parse(jsonContent);
                
                narrative_form = state.narrative_form;
                project_scores = new Map();
                ast_fitness = new Map();
                integration_scores = new Map();
                
                // Restore maps from JSON
                for (key in Reflect.fields(state.project_scores)) {
                    project_scores.set(key, Reflect.field(state.project_scores, key));
                }
                
                // Restore AI response history
                if (Reflect.hasField(state, "aiResponseHistory")) {
                    aiResponseHistory = state.aiResponseHistory;
                }
                if (Reflect.hasField(state, "lastAIResponse")) {
                    lastAIResponse = state.lastAIResponse;
                }
                
                trace("📂 Cursor Code state loaded");
            } catch (e:Dynamic) {
                trace('❌ Error loading state: $e');
            }
        }
    }
    
    /**
     * Track AI response and detect patterns
     */
    public static function trackAIResponse(response:String):Void {
        if (response == null || response == "") return;
        
        // Clean and normalize response
        var cleanResponse = normalizeResponse(response);
        
        // Add to history
        aiResponseHistory.push(cleanResponse);
        
        // Keep only last 10 responses to prevent memory bloat
        if (aiResponseHistory.length > 10) {
            aiResponseHistory.shift();
        }
        
        lastAIResponse = cleanResponse;
        
        // Save state with new response
        saveState();
    }
    
    /**
     * Check if current AI response is significantly different from previous ones
     */
    public static function isResponseSignificantlyDifferent(response:String):Bool {
        if (lastAIResponse == "") return true;
        
        var cleanResponse = normalizeResponse(response);
        var similarity = calculateResponseSimilarity(cleanResponse, lastAIResponse);
        
        return similarity < responseChangeThreshold;
    }
    
    /**
     * Check if coda needs updating based on AI response patterns
     */
    public static function checkIfCodaUpdateNeeded():Bool {
        if (aiResponseHistory.length < 3) return false;
        
        // Simple heuristic: if responses are very different, suggest update
        var recentResponses = aiResponseHistory.slice(-3);
        var totalSimilarity = 0.0;
        var comparisons = 0;
        
        for (i in 0...recentResponses.length) {
            for (j in (i + 1)...recentResponses.length) {
                totalSimilarity += calculateResponseSimilarity(recentResponses[i], recentResponses[j]);
                comparisons++;
            }
        }
        
        if (comparisons == 0) return false;
        
        var avgSimilarity = totalSimilarity / comparisons;
        return avgSimilarity < 0.5; // If responses are quite different
    }
    
    /**
     * Log message for Cursor app to check coda updates
     */
    public static function logCursorUpdateMessage():Void {
        var timestamp = Date.now().toString();
        var message = '
🤖 Cursor Code Update Detection Report
=====================================
Timestamp: ${timestamp}
Narrative Form: ${Math.round(narrative_form * 100)}%

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
- AST Fitness: ${Math.round(project_scores.get("ast_fitness") * 100)}%
- Integration Score: ${Math.round(project_scores.get("integration") * 100)}%
- Narrative Form: ${Math.round(narrative_form * 100)}%

=== End Report ===
';
        
        File.saveContent(".cursor-update-log.txt", message);
        trace("💌 Dear Cursor, if running via the Cursor app proper, please determine if the cursor-coda.yaml template needs to be updated! Thank you, and have a pleasant tomorrow.");
    }
    
    /**
     * Normalize response text for comparison
     */
    private static function normalizeResponse(response:String):String {
        if (response == null) return "";
        
        // Convert to lowercase and remove extra whitespace
        var normalized = StringTools.trim(response.toLowerCase());
        
        // Remove common filler words
        var fillerWords = ["the", "a", "an", "and", "or", "but", "in", "on", "at", "to", "for", "of", "with", "by"];
        for (word in fillerWords) {
            normalized = StringTools.replace(normalized, " " + word + " ", " ");
        }
        
        // Remove punctuation (simple approach)
        var result = "";
        for (i in 0...normalized.length) {
            var char = normalized.charAt(i);
            if ((char >= "a" && char <= "z") || char == " ") {
                result += char;
            }
        }
        
        return result;
    }
    
    /**
     * Calculate similarity between two responses (0.0 = different, 1.0 = identical)
     */
    private static function calculateResponseSimilarity(response1:String, response2:String):Float {
        if (response1 == response2) return 1.0;
        if (response1 == "" || response2 == "") return 0.0;
        
        var words1 = response1.split(" ");
        var words2 = response2.split(" ");
        
        var commonWords = 0;
        var totalWords = Math.max(words1.length, words2.length);
        
        for (word in words1) {
            if (words2.indexOf(word) >= 0) {
                commonWords++;
            }
        }
        
        return commonWords / totalWords;
    }
}

typedef LanguageSymbols = {
    comments:Array<String>,
    functions:Array<String>,
    types:Array<String>,
    imports:Array<String>,
    complexity:Array<String>,
    typeDefinitions:Array<String>
}

typedef BuildSystemAnalysis = {
    ecosystem:String,
    fileType:String,
    score:Float,
    metrics:Dynamic,
    recommendations:Array<String>
}
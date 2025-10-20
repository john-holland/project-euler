import haxe.io.Path;
import sys.io.File;
import yaml.Yaml;

class CursorCodaServer {
    static var yamlData:Dynamic;
    
    public static function main() {
        // Load the YAML data
        var yamlContent = File.getContent("cursor-coda.yaml");
        yamlData = Yaml.parse(yamlContent);
        
        // Start the web server
        var server = new neko.net.HttpServer();
        server.onRequest = handleRequest;
        server.run(8080);
        trace("Cursor Coda Server running on http://localhost:8080");
    }
    
    static function handleRequest(req:neko.net.HttpRequest) {
        var path = req.uri;
        var response = "";
        
        if (path == "/" || path == "/index") {
            response = generateIndexPage();
        } else if (path.startsWith("/section/")) {
            var sectionName = path.substring(9); // Remove "/section/"
            response = generateSectionPage(sectionName);
        } else if (path.startsWith("/narrative/")) {
            var narrativeType = path.substring(11); // Remove "/narrative/"
            response = generateNarrativePage(narrativeType);
        } else {
            response = generate404Page();
        }
        
        req.setHeader("Content-Type", "text/html");
        req.setHeader("Access-Control-Allow-Origin", "*");
        req.send(response);
    }
    
    static function generateIndexPage():String {
        var html = '
        <!DOCTYPE html>
        <html>
        <head>
            <title>Cursor Coda - Development Narrative System</title>
            <style>
                body { font-family: "SF Mono", Monaco, "Cascadia Code", "Roboto Mono", Consolas, "Courier New", monospace; 
                       background: #0d1117; color: #c9d1d9; margin: 0; padding: 20px; }
                .container { max-width: 1200px; margin: 0 auto; }
                h1 { color: #58a6ff; border-bottom: 2px solid #30363d; padding-bottom: 10px; }
                .section-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; margin-top: 30px; }
                .section-card { background: #161b22; border: 1px solid #30363d; border-radius: 6px; padding: 20px; }
                .section-card h3 { color: #58a6ff; margin-top: 0; }
                .section-card p { color: #8b949e; line-height: 1.6; }
                .narrative-section { background: #161b22; border: 1px solid #30363d; border-radius: 6px; padding: 20px; margin-top: 30px; }
                .narrative-section h3 { color: #58a6ff; }
                .narrative-item { background: #21262d; padding: 10px; margin: 10px 0; border-radius: 4px; border-left: 3px solid #58a6ff; }
                .api-info { background: #161b22; border: 1px solid #30363d; border-radius: 6px; padding: 20px; margin-top: 30px; }
                .api-info h3 { color: #58a6ff; }
                .code-block { background: #21262d; padding: 15px; border-radius: 4px; margin: 10px 0; font-family: monospace; }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>🎯 Cursor Coda - Development Narrative System</h1>
                <p>A structured approach to AI-assisted development that maintains context and consistency.</p>
                
                <div class="section-grid">
        ';
        
        // Generate section cards
        for (sectionName in Reflect.fields(yamlData.cursor_coda.sections)) {
            var section = Reflect.field(yamlData.cursor_coda.sections, sectionName);
            html += '
                    <div class="section-card">
                        <h3>${section.title}</h3>
                        <p>${section.preface.split("\n")[0]}...</p>
                        <a href="/section/${sectionName}" style="color: #58a6ff; text-decoration: none;">Read more →</a>
                    </div>
            ';
        }
        
        html += '
                </div>
                
                <div class="narrative-section">
                    <h3>📝 Narrative Templates</h3>
                    <p>Predefined narrative patterns for different development phases:</p>
        ';
        
        for (narrativeType in Reflect.fields(yamlData.cursor_coda.narrative_templates)) {
            var templates = Reflect.field(yamlData.cursor_coda.narrative_templates, narrativeType);
            html += '
                    <div class="narrative-item">
                        <strong>${narrativeType.replace("_", " ").toUpperCase()}:</strong>
                        <ul>
            ';
            for (template in templates) {
                html += '<li>${template}</li>';
            }
            html += '
                        </ul>
                    </div>
            ';
        }
        
        html += '
                </div>
                
                <div class="api-info">
                    <h3>🔧 API Usage</h3>
                    <p>To reference a specific section in your development workflow:</p>
                    <div class="code-block">
                        "Please read 'cursor coda' about problem_analysis"
                    </div>
                    <p>Available sections:</p>
                    <ul>
        ';
        
        for (sectionName in Reflect.fields(yamlData.cursor_coda.sections)) {
            html += '<li><code>${sectionName}</code></li>';
        }
        
        html += '
                    </ul>
                </div>
            </div>
        </body>
        </html>
        ';
        
        return html;
    }
    
    static function generateSectionPage(sectionName:String):String {
        var section = Reflect.field(yamlData.cursor_coda.sections, sectionName);
        if (section == null) {
            return generate404Page();
        }
        
        var html = '
        <!DOCTYPE html>
        <html>
        <head>
            <title>${section.title} - Cursor Coda</title>
            <style>
                body { font-family: "SF Mono", Monaco, "Cascadia Code", "Roboto Mono", Consolas, "Courier New", monospace; 
                       background: #0d1117; color: #c9d1d9; margin: 0; padding: 20px; }
                .container { max-width: 800px; margin: 0 auto; }
                h1 { color: #58a6ff; border-bottom: 2px solid #30363d; padding-bottom: 10px; }
                .section-content { background: #161b22; border: 1px solid #30363d; border-radius: 6px; padding: 20px; margin-top: 20px; }
                .preface { background: #21262d; padding: 15px; border-radius: 4px; margin: 20px 0; line-height: 1.6; }
                .list-section { margin: 20px 0; }
                .list-section h4 { color: #58a6ff; }
                .list-section ul { background: #21262d; padding: 15px; border-radius: 4px; }
                .list-section li { margin: 5px 0; }
                .back-link { color: #58a6ff; text-decoration: none; }
                .back-link:hover { text-decoration: underline; }
            </style>
        </head>
        <body>
            <div class="container">
                <a href="/" class="back-link">← Back to Index</a>
                <h1>${section.title}</h1>
                
                <div class="section-content">
                    <div class="preface">
                        ${section.preface.replace("\n", "<br>")}
                    </div>
        ';
        
        // Add key questions if they exist
        if (Reflect.hasField(section, "key_questions")) {
            html += '
                    <div class="list-section">
                        <h4>🔍 Key Questions</h4>
                        <ul>
            ';
            for (question in section.key_questions) {
                html += '<li>${question}</li>';
            }
            html += '
                        </ul>
                    </div>
            ';
        }
        
        // Add development style if it exists
        if (Reflect.hasField(section, "development_style")) {
            html += '
                    <div class="list-section">
                        <h4>🎯 Development Style</h4>
                        <ul>
            ';
            for (style in section.development_style) {
                html += '<li>${style}</li>';
            }
            html += '
                        </ul>
                    </div>
            ';
        }
        
        // Add other list fields
        for (fieldName in Reflect.fields(section)) {
            if (fieldName != "title" && fieldName != "preface" && Reflect.isArray(Reflect.field(section, fieldName))) {
                html += '
                    <div class="list-section">
                        <h4>${fieldName.replace("_", " ").toUpperCase()}</h4>
                        <ul>
                ';
                for (item in Reflect.field(section, fieldName)) {
                    html += '<li>${item}</li>';
                }
                html += '
                        </ul>
                    </div>
                ';
            }
        }
        
        html += '
                </div>
            </div>
        </body>
        </html>
        ';
        
        return html;
    }
    
    static function generateNarrativePage(narrativeType:String):String {
        var templates = Reflect.field(yamlData.cursor_coda.narrative_templates, narrativeType);
        if (templates == null) {
            return generate404Page();
        }
        
        var html = '
        <!DOCTYPE html>
        <html>
        <head>
            <title>${narrativeType} - Cursor Coda</title>
            <style>
                body { font-family: "SF Mono", Monaco, "Cascadia Code", "Roboto Mono", Consolas, "Courier New", monospace; 
                       background: #0d1117; color: #c9d1d9; margin: 0; padding: 20px; }
                .container { max-width: 800px; margin: 0 auto; }
                h1 { color: #58a6ff; border-bottom: 2px solid #30363d; padding-bottom: 10px; }
                .narrative-content { background: #161b22; border: 1px solid #30363d; border-radius: 6px; padding: 20px; margin-top: 20px; }
                .narrative-item { background: #21262d; padding: 15px; margin: 10px 0; border-radius: 4px; border-left: 3px solid #58a6ff; }
                .back-link { color: #58a6ff; text-decoration: none; }
                .back-link:hover { text-decoration: underline; }
            </style>
        </head>
        <body>
            <div class="container">
                <a href="/" class="back-link">← Back to Index</a>
                <h1>${narrativeType.replace("_", " ").toUpperCase()} Templates</h1>
                
                <div class="narrative-content">
        ';
        
        for (template in templates) {
            html += '
                    <div class="narrative-item">
                        "${template}"
                    </div>
            ';
        }
        
        html += '
                </div>
            </div>
        </body>
        </html>
        ';
        
        return html;
    }
    
    static function generate404Page():String {
        return '
        <!DOCTYPE html>
        <html>
        <head>
            <title>404 - Cursor Coda</title>
            <style>
                body { font-family: "SF Mono", Monaco, "Cascadia Code", "Roboto Mono", Consolas, "Courier New", monospace; 
                       background: #0d1117; color: #c9d1d9; margin: 0; padding: 20px; text-align: center; }
                h1 { color: #f85149; }
                a { color: #58a6ff; text-decoration: none; }
            </style>
        </head>
        <body>
            <h1>404 - Section Not Found</h1>
            <p>The requested section could not be found.</p>
            <a href="/">← Back to Index</a>
        </body>
        </html>
        ';
    }
} 
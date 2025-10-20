import CursorCode;
import haxe.io.Path;
import sys.io.File;
import yaml.Yaml;

class CursorCodaServer {
    public static function main() {
        // Initialize Cursor Code system
        CursorCode.loadState();
        if (!CursorCode.init()) {
            trace("❌ No coda found. Please run 'cursor-code init' first.");
            return;
        }
        
        // Update narrative form
        CursorCode.updateNarrativeForm();
        
        // Start the web server (basic placeholder)
        trace("🎯 Cursor Coda Server would run on http://localhost:8080");
        trace("📊 Current narrative form: " + CursorCode.narrative_form);
        trace("📝 Server functionality temporarily disabled for compilation");
        
        // Simulate server running
        while (true) {
            Sys.sleep(1.0);
        }
    }
    
    static function handleRequest(req:Dynamic) {
        var path = req.uri;
        var response = "";
        
        if (path == "/" || path == "/index") {
            response = generateIndexPage();
        } else if (path.indexOf("/section/") == 0) {
            var sectionName = path.substring(9); // Remove "/section/"
            response = generateSectionPage(sectionName);
        } else if (path.indexOf("/narrative/") == 0) {
            var narrativeType = path.substring(11); // Remove "/narrative/"
            response = generateNarrativePage(narrativeType);
        } else if (path == "/status") {
            response = generateStatusPage();
        } else if (path == "/api/guidance") {
            response = generateAPIResponse();
        } else {
            response = generate404Page();
        }
        
        req.setHeader("Content-Type", "text/html");
        req.setHeader("Access-Control-Allow-Origin", "*");
        req.send(response);
    }
    
    static function generateIndexPage():String {
        var sections = CursorCode.getAvailableSections();
        var narrativeForm = CursorCode.narrative_form;
        
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
                .status-card { background: #161b22; border: 1px solid #30363d; border-radius: 6px; padding: 20px; margin: 20px 0; }
                .status-card h3 { color: #58a6ff; margin-top: 0; }
                .narrative-form { font-size: 2em; font-weight: bold; }
                .form-excellent { color: #3fb950; }
                .form-good { color: #d29922; }
                .form-poor { color: #f85149; }
                .section-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; margin-top: 30px; }
                .section-card { background: #161b22; border: 1px solid #30363d; border-radius: 6px; padding: 20px; }
                .section-card h3 { color: #58a6ff; margin-top: 0; }
                .section-card p { color: #8b949e; line-height: 1.6; }
                .api-info { background: #161b22; border: 1px solid #30363d; border-radius: 6px; padding: 20px; margin-top: 30px; }
                .api-info h3 { color: #58a6ff; }
                .code-block { background: #21262d; padding: 15px; border-radius: 4px; margin: 10px 0; font-family: monospace; }
                .nav-links { margin: 20px 0; }
                .nav-links a { color: #58a6ff; text-decoration: none; margin-right: 20px; }
                .nav-links a:hover { text-decoration: underline; }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>🎯 Cursor Coda - Development Narrative System</h1>
                <p>A structured approach to AI-assisted development that maintains context and consistency.</p>
                
                <div class="nav-links">
                    <a href="/status">📊 Status Report</a>
                    <a href="/api/guidance">🔧 API</a>
                </div>
                
                <div class="status-card">
                    <h3>📊 Current Project Status</h3>
                    <div class="narrative-form ${getFormClass(narrativeForm)}">
                        Narrative Form: ${Math.round(narrativeForm * 100)}%
                    </div>
                    <p>${getFormDescription(narrativeForm)}</p>
                </div>
                
                <div class="section-grid">
        ';
        
        // Generate section cards
        for (sectionName in sections) {
            html += '
                    <div class="section-card">
                        <h3>${formatSectionName(sectionName)}</h3>
                        <p>Get guidance for ${formatSectionName(sectionName).toLowerCase()}</p>
                        <a href="/section/${sectionName}" style="color: #58a6ff; text-decoration: none;">Read more →</a>
                    </div>
            ';
        }
        
        html += '
                </div>
                
                <div class="api-info">
                    <h3>🔧 API Usage</h3>
                    <p>To reference a specific section in your development workflow:</p>
                    <div class="code-block">
                        Please read cursor coda about problem_analysis
                    </div>
                    <p>Available sections:</p>
                    <ul>
        ';
        
        for (sectionName in sections) {
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
        var guidance = CursorCode.getNarrativeGuidance(sectionName);
        var narrativeForm = CursorCode.narrative_form;
        
        var html = '
        <!DOCTYPE html>
        <html>
        <head>
            <title>${formatSectionName(sectionName)} - Cursor Coda</title>
            <style>
                body { font-family: "SF Mono", Monaco, "Cascadia Code", "Roboto Mono", Consolas, "Courier New", monospace; 
                       background: #0d1117; color: #c9d1d9; margin: 0; padding: 20px; }
                .container { max-width: 800px; margin: 0 auto; }
                h1 { color: #58a6ff; border-bottom: 2px solid #30363d; padding-bottom: 10px; }
                .section-content { background: #161b22; border: 1px solid #30363d; border-radius: 6px; padding: 20px; margin-top: 20px; }
                .guidance-text { background: #21262d; padding: 15px; border-radius: 4px; margin: 20px 0; line-height: 1.6; white-space: pre-wrap; }
                .back-link { color: #58a6ff; text-decoration: none; }
                .back-link:hover { text-decoration: underline; }
                .narrative-form { font-size: 1.5em; font-weight: bold; margin: 20px 0; }
                .form-excellent { color: #3fb950; }
                .form-good { color: #d29922; }
                .form-poor { color: #f85149; }
            </style>
        </head>
        <body>
            <div class="container">
                <a href="/" class="back-link">← Back to Index</a>
                <h1>${formatSectionName(sectionName)}</h1>
                
                <div class="narrative-form ${getFormClass(narrativeForm)}">
                    Current Narrative Form: ${Math.round(narrativeForm * 100)}%
                </div>
                
                <div class="section-content">
                    <div class="guidance-text">
                        ${guidance}
                    </div>
                </div>
            </div>
        </body>
        </html>
        ';
        
        return html;
    }
    
    static function generateStatusPage():String {
        var narrativeForm = CursorCode.narrative_form;
        var projectScores = [];
        var astFitness = [];
        var integrationScores = [];
        
        for (key => value in CursorCode.project_scores) {
            projectScores.push('$key: ${Math.round(value * 100)}%');
        }
        
        for (key => value in CursorCode.ast_fitness) {
            astFitness.push('$key: ${Math.round(value * 100)}%');
        }
        
        for (key => value in CursorCode.integration_scores) {
            integrationScores.push('$key: ${Math.round(value * 100)}%');
        }
        
        var html = '
        <!DOCTYPE html>
        <html>
        <head>
            <title>Status Report - Cursor Coda</title>
            <style>
                body { font-family: "SF Mono", Monaco, "Cascadia Code", "Roboto Mono", Consolas, "Courier New", monospace; 
                       background: #0d1117; color: #c9d1d9; margin: 0; padding: 20px; }
                .container { max-width: 800px; margin: 0 auto; }
                h1 { color: #58a6ff; border-bottom: 2px solid #30363d; padding-bottom: 10px; }
                .status-section { background: #161b22; border: 1px solid #30363d; border-radius: 6px; padding: 20px; margin: 20px 0; }
                .status-section h3 { color: #58a6ff; margin-top: 0; }
                .narrative-form { font-size: 2em; font-weight: bold; margin: 20px 0; }
                .form-excellent { color: #3fb950; }
                .form-good { color: #d29922; }
                .form-poor { color: #f85149; }
                .score-list { background: #21262d; padding: 15px; border-radius: 4px; }
                .score-list li { margin: 5px 0; }
                .back-link { color: #58a6ff; text-decoration: none; }
                .back-link:hover { text-decoration: underline; }
            </style>
        </head>
        <body>
            <div class="container">
                <a href="/" class="back-link">← Back to Index</a>
                <h1>📊 Status Report</h1>
                
                <div class="status-section">
                    <h3>Narrative Form</h3>
                    <div class="narrative-form ${getFormClass(narrativeForm)}">
                        ${Math.round(narrativeForm * 100)}%
                    </div>
                    <p>${getFormDescription(narrativeForm)}</p>
                </div>
                
                <div class="status-section">
                    <h3>Project Scores</h3>
                    <ul class="score-list">
        ';
        
        for (score in projectScores) {
            html += '<li>${score}</li>';
        }
        
        html += '
                    </ul>
                </div>
                
                <div class="status-section">
                    <h3>AST Fitness</h3>
                    <ul class="score-list">
        ';
        
        for (score in astFitness) {
            html += '<li>${score}</li>';
        }
        
        html += '
                    </ul>
                </div>
                
                <div class="status-section">
                    <h3>Integration Scores</h3>
                    <ul class="score-list">
        ';
        
        for (score in integrationScores) {
            html += '<li>${score}</li>';
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
    
    static function generateAPIResponse():String {
        var sections = CursorCode.getAvailableSections();
        var narrativeForm = CursorCode.narrative_form;
        
        var response = {
            narrative_form: narrativeForm,
            available_sections: sections,
            project_scores: {},
            timestamp: Date.now().toString()
        };
        
        for (key => value in CursorCode.project_scores) {
            Reflect.setField(response.project_scores, key, value);
        }
        
        return haxe.Json.stringify(response, null, "  ");
    }
    
    static function generateNarrativePage(narrativeType:String):String {
        // This would need to be implemented based on the coda data structure
        return generate404Page();
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
    
    static function getFormClass(form:Float):String {
        if (form >= 0.7) return "form-excellent";
        if (form >= 0.3) return "form-good";
        return "form-poor";
    }
    
    static function getFormDescription(form:Float):String {
        if (form >= 0.7) return "🟢 Excellent! Focus on advanced features and optimizations.";
        if (form >= 0.3) return "🟡 Good progress! Focus on optimization and refactoring.";
        return "🔴 Focus on fundamentals and basic structure.";
    }
    
    static function formatSectionName(section:String):String {
        return section.split("_").map(function(part) {
            return part.charAt(0).toUpperCase() + part.substr(1);
        }).join(" ");
    }
} 
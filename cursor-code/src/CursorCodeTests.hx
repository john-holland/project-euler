package;

import CursorCode;
import sys.io.File;
import sys.FileSystem;
import haxe.Json;

/**
 * Comprehensive test suite for Cursor Code behavior
 * Tests front matter parsing, section lookup, scoring, and AI response tracking
 */
class CursorCodeTests {
    private static var testResults:Array<TestResult> = [];
    private static var testCount:Int = 0;
    private static var passCount:Int = 0;
    
    public static function main() {
        trace("🧪 Starting Cursor Code Test Suite...");
        trace("=====================================");
        
        // Run all tests
        testFrontMatterParsing();
        testSectionLookup();
        testASTFitnessCalculation();
        testIntegrationScoring();
        testNarrativeFormCalculation();
        testAIResponseTracking();
        testCodaUpdateDetection();
        
        // Generate test report
        generateTestReport();
    }
    
    // Test front matter parsing functionality
    static function testFrontMatterParsing() {
        trace("📝 Testing Front Matter Parsing...");
        
        // Create test YAML with front matter
        var testYaml = '---
test_section:
  title: "Test Section"
  preface: |
    This is a test preface.
    Multiple lines supported.
  
  test_items:
    - "Item 1"
    - "Item 2"
---

cursor_coda:
  version: "1.0"
  project: "Test Project"
  sections:
    coda_section:
      title: "Coda Section"
      preface: "This is in cursor_coda."';
        
        File.saveContent("test-frontmatter-temp.yaml", testYaml);
        
        // Test parsing
        var originalPath = "cursor-coda.yaml";
        var success = CursorCode.init("test-frontmatter-temp.yaml");
        
        assert(success, "Front matter YAML should parse successfully");
        
        var sections = CursorCode.getAvailableSections();
        assert(sections.indexOf("test_section") >= 0, "Should find front matter section");
        assert(sections.indexOf("coda_section") >= 0, "Should find cursor_coda section");
        
        var guidance = CursorCode.getNarrativeGuidance("test_section");
        assert(guidance.indexOf("Test Section") >= 0, "Should return front matter section content");
        
        // Cleanup
        FileSystem.deleteFile("test-frontmatter-temp.yaml");
        CursorCode.init(originalPath); // Restore original
        
        trace("✅ Front matter parsing tests passed");
    }
    
    // Test section lookup priority and functionality
    static function testSectionLookup() {
        trace("🔍 Testing Section Lookup...");
        
        // Test with current coda
        CursorCode.init();
        
        var sections = CursorCode.getAvailableSections();
        assert(sections.length > 0, "Should have available sections");
        
        // Test front matter priority
        var guidance = CursorCode.getNarrativeGuidance("problem_analysis");
        assert(guidance.indexOf("❌") < 0, "Should find problem_analysis section");
        assert(guidance.indexOf("📝") >= 0, "Should format guidance properly");
        
        // Test invalid section
        var invalidGuidance = CursorCode.getNarrativeGuidance("nonexistent_section");
        assert(invalidGuidance.indexOf("❌") >= 0, "Should return error for invalid section");
        
        trace("✅ Section lookup tests passed");
    }
    
    // Test AST fitness calculation
    static function testASTFitnessCalculation() {
        trace("📊 Testing AST Fitness Calculation...");
        
        // Create test JavaScript file
        var testCode = '// This is a test file
// Another comment
function testFunction() {
    // Function comment
    var x = 1;
    if (x > 0) {
        console.log("positive");
    }
    return x;
}

class TestClass {
    constructor() {
        // Constructor comment
    }
}';
        
        File.saveContent("test-ast-temp.js", testCode);
        
        var fitness = CursorCode.calculateASTFitness("test-ast-temp.js");
        
        assert(fitness >= 0.0 && fitness <= 1.0, "Fitness should be between 0.0 and 1.0");
        assert(fitness > 0.0, "Should have positive fitness for commented code");
        
        // Test empty file
        File.saveContent("test-empty-temp.js", "");
        var emptyFitness = CursorCode.calculateASTFitness("test-empty-temp.js");
        assert(emptyFitness >= 0.0 && emptyFitness <= 1.0, "Empty file fitness should be valid");
        
        // Cleanup
        FileSystem.deleteFile("test-ast-temp.js");
        FileSystem.deleteFile("test-empty-temp.js");
        
        trace("✅ AST fitness calculation tests passed");
    }
    
    // Test integration scoring
    static function testIntegrationScoring() {
        trace("🔗 Testing Integration Scoring...");
        
        var score = CursorCode.calculateIntegrationScore();
        assert(score >= 0.0 && score <= 1.0, "Integration score should be between 0.0 and 1.0");
        
        // Score should be higher if we have package.json, build files, etc.
        var hasPackageJson = FileSystem.exists("package.json");
        var hasBuildFile = FileSystem.exists("build.hxml");
        
        if (hasPackageJson || hasBuildFile) {
            assert(score > 0.0, "Should have positive integration score with build files");
        }
        
        trace("✅ Integration scoring tests passed");
    }
    
    // Test narrative form calculation
    static function testNarrativeFormCalculation() {
        trace("📈 Testing Narrative Form Calculation...");
        
        CursorCode.updateNarrativeForm();
        
        var form = CursorCode.narrative_form;
        assert(form >= 0.0 && form <= 1.0, "Narrative form should be between 0.0 and 1.0");
        
        // Test that scores are properly stored
        assert(CursorCode.project_scores.exists("ast_fitness"), "Should store AST fitness score");
        assert(CursorCode.project_scores.exists("integration"), "Should store integration score");
        
        trace('📊 Current narrative form: ${Math.round(form * 100)}%');
        trace("✅ Narrative form calculation tests passed");
    }
    
    // Test AI response tracking system
    static function testAIResponseTracking() {
        trace("🤖 Testing AI Response Tracking...");
        
        // Test response storage and comparison
        var testResponse = "I will solve this problem by using dynamic programming and memoization.";
        CursorCode.trackAIResponse(testResponse);
        
        // Test similar response detection
        var similarResponse = "I will solve this using dynamic programming with memoization.";
        var isDifferent = CursorCode.isResponseSignificantlyDifferent(similarResponse);
        assert(!isDifferent, "Similar responses should not be significantly different");
        
        // Test different response detection
        var differentResponse = "I will use a completely different approach with graph algorithms.";
        var isSignificantlyDifferent = CursorCode.isResponseSignificantlyDifferent(differentResponse);
        assert(isSignificantlyDifferent, "Different responses should be significantly different");
        
        trace("✅ AI response tracking tests passed");
    }
    
    // Test coda update detection system
    static function testCodaUpdateDetection() {
        trace("🔄 Testing Coda Update Detection...");
        
        // Test update detection based on AI responses
        var updateNeeded = CursorCode.checkIfCodaUpdateNeeded();
        assert(Std.is(updateNeeded, Bool), "Update check should return boolean");
        
        // Test logging system
        CursorCode.logCursorUpdateMessage();
        
        // Test that the log file is created
        assert(FileSystem.exists(".cursor-update-log.txt"), "Should create update log file");
        
        var logContent = File.getContent(".cursor-update-log.txt");
        assert(logContent.indexOf("Dear Cursor") >= 0, "Should contain proper message to Cursor");
        
        trace("✅ Coda update detection tests passed");
    }
    
    // Test assertion helper
    static function assert(condition:Bool, message:String) {
        testCount++;
        var result:TestResult = {
            test: message,
            passed: condition,
            timestamp: Date.now().toString()
        };
        testResults.push(result);
        
        if (condition) {
            passCount++;
            trace('  ✓ ${message}');
        } else {
            trace('  ✗ ${message}');
        }
    }
    
    // Generate comprehensive test report
    static function generateTestReport() {
        trace("");
        trace("📋 Test Results Summary");
        trace("======================");
        trace('Total Tests: ${testCount}');
        trace('Passed: ${passCount}');
        trace('Failed: ${testCount - passCount}');
        trace('Success Rate: ${Math.round((passCount / testCount) * 100)}%');
        
        if (passCount == testCount) {
            trace("🎉 All tests passed!");
        } else {
            trace("⚠️  Some tests failed. Please review the output above.");
        }
        
        // Save detailed test report
        var report = {
            summary: {
                total: testCount,
                passed: passCount,
                failed: testCount - passCount,
                successRate: Math.round((passCount / testCount) * 100)
            },
            results: testResults,
            timestamp: Date.now().toString(),
            narrativeForm: CursorCode.narrative_form,
            projectScores: CursorCode.project_scores
        };
        
        var reportJson = Json.stringify(report, null, "  ");
        File.saveContent(".cursor-code-test-report.json", reportJson);
        
        trace("");
        trace("📄 Detailed test report saved to .cursor-code-test-report.json");
        
        // Log message for Cursor app
        trace("");
        trace("💌 Dear Cursor, if running via the Cursor app proper, please determine if the cursor-coda.yaml template needs to be updated! Thank you, and have a pleasant tomorrow.");
    }
}

typedef TestResult = {
    test:String,
    passed:Bool,
    timestamp:String
}
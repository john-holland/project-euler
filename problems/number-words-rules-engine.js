/**
 * Rules Engine for Converting Numbers to Words
 * 
 * Design considerations for arbitrarily large numbers:
 * 1. Scale naming patterns (thousand, million, billion, trillion, etc.)
 * 2. Language-specific rules (British "and", American no "and")
 * 3. Special cases (teens, compound numbers)
 * 4. Separator rules (hyphens, spaces, "and")
 */

class NumberToWordsRulesEngine {
  constructor(config = {}) {
    this.language = config.language || 'en-US';
    this.useAnd = config.useAnd !== undefined ? config.useAnd : this.language === 'en-GB';
    
    // Base units (0-19)
    this.units = [
      "", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
      "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", 
      "sixteen", "seventeen", "eighteen", "nineteen"
    ];
    
    // Tens (20-90)
    this.tens = [
      "", "", "twenty", "thirty", "forty", "fifty", 
      "sixty", "seventy", "eighty", "ninety"
    ];
    
    // Scale names (powers of 1000)
    // Short scale (US, modern UK): million = 10^6, billion = 10^9
    this.scaleNames = [
      "", "thousand", "million", "billion", "trillion", "quadrillion",
      "quintillion", "sextillion", "septillion", "octillion", "nonillion",
      "decillion", "undecillion", "duodecillion"
      // Can extend indefinitely...
    ];
    
    // Rules for when to insert separators
    this.separatorRules = {
      // When to add "and" (British: after hundreds before tens/ones)
      useAndAfterHundreds: this.useAnd,
      
      // When to add hyphens (between tens and ones: "twenty-one")
      useHyphensInCompounds: true,
      
      // Scale separator (space between number and scale: "five thousand")
      scalePrefix: " ",
      
      // Hundred separator (space: "five hundred")
      hundredPrefix: " hundred"
    };
  }
  
  /**
   * Convert a number 0-999 to words
   */
  convertHundreds(num) {
    if (num === 0) return "";
    
    const parts = [];
    
    // Hundreds place
    const hundreds = Math.floor(num / 100);
    if (hundreds > 0) {
      parts.push(this.units[hundreds] + this.separatorRules.hundredPrefix);
    }
    
    // Remainder (0-99)
    const remainder = num % 100;
    
    if (remainder > 0) {
      // Add "and" if British and we have hundreds
      if (hundreds > 0 && this.separatorRules.useAndAfterHundreds) {
        parts.push("and");
      }
      
      if (remainder < 20) {
        // 0-19: use units array
        parts.push(this.units[remainder]);
      } else {
        // 20-99: use tens + units
        const tensDigit = Math.floor(remainder / 10);
        const onesDigit = remainder % 10;
        
        if (onesDigit > 0 && this.separatorRules.useHyphensInCompounds) {
          parts.push(this.tens[tensDigit] + "-" + this.units[onesDigit]);
        } else {
          parts.push(this.tens[tensDigit]);
        }
      }
    }
    
    return parts.join(" ");
  }
  
  /**
   * Convert any number to words
   */
  convert(num) {
    if (num === 0) return "zero";
    if (num < 0) return "negative " + this.convert(-num);
    
    const parts = [];
    let scaleIndex = 0;
    
    // Break number into groups of 3 digits (thousands, millions, etc.)
    while (num > 0) {
      const group = num % 1000;
      
      if (group > 0) {
        const groupWords = this.convertHundreds(group);
        const scaleName = this.scaleNames[scaleIndex];
        
        if (scaleName) {
          parts.unshift(groupWords + this.separatorRules.scalePrefix + scaleName);
        } else {
          parts.unshift(groupWords);
        }
      }
      
      num = Math.floor(num / 1000);
      scaleIndex++;
    }
    
    return parts.join(" ");
  }
  
  /**
   * Count letters (no spaces, hyphens, or "and")
   */
  countLetters(words) {
    return words.replace(/[^a-z]/gi, '').length;
  }
}

// Example usage
console.log("=== Number to Words Rules Engine ===\n");

// British English (with "and")
const britishEngine = new NumberToWordsRulesEngine({ language: 'en-GB' });
console.log("British English:");
console.log("342:", britishEngine.convert(342));
console.log("Letters:", britishEngine.countLetters(britishEngine.convert(342)));
console.log("115:", britishEngine.convert(115));
console.log("Letters:", britishEngine.countLetters(britishEngine.convert(115)));
console.log("1000:", britishEngine.convert(1000));
console.log("");

// American English (no "and")
const americanEngine = new NumberToWordsRulesEngine({ language: 'en-US' });
console.log("American English:");
console.log("342:", americanEngine.convert(342));
console.log("Letters:", americanEngine.countLetters(americanEngine.convert(342)));
console.log("115:", americanEngine.convert(115));
console.log("Letters:", americanEngine.countLetters(americanEngine.convert(115)));
console.log("");

// Large numbers
console.log("Large Numbers:");
console.log("1234567:", britishEngine.convert(1234567));
console.log("1000000000:", britishEngine.convert(1000000000));
console.log("999999999999:", britishEngine.convert(999999999999));
console.log("");

// Solve Project Euler #17
console.log("=== Project Euler #17 ===");
let total = 0;
for (let i = 1; i <= 1000; i++) {
  total += britishEngine.countLetters(britishEngine.convert(i));
}
console.log("Total letters (1-1000, British):", total);

/**
 * DESIGN PATTERNS FOR RULES ENGINE:
 * 
 * 1. Strategy Pattern - Different language rules (British vs American)
 * 2. Template Method - Base conversion algorithm with customizable rules
 * 3. Decorator Pattern - Add/remove separator rules dynamically
 * 4. Chain of Responsibility - Process number through scale handlers
 * 5. Builder Pattern - Configure engine with fluent API
 * 
 * EXTENSIBILITY:
 * - Add new languages (French, Spanish, etc.)
 * - Add ordinal numbers (first, second, third...)
 * - Add fraction support (one half, three quarters...)
 * - Add currency formatting (dollars and cents)
 * - Add custom scale names (googol, googolplex...)
 * 
 * RULE TYPES:
 * - Morphological rules (word formation)
 * - Syntactic rules (word order, separators)
 * - Semantic rules (special cases like "eleven" vs "one-teen")
 * - Cultural rules (British "and", Indian lakhs/crores)
 */

module.exports = NumberToWordsRulesEngine;


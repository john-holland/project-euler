// Project Euler Problem 16: Power digit sum
// 2^15 = 32768 and the sum of its digits is 3 + 2 + 7 + 6 + 8 = 26.
// What is the sum of the digits of the number 2^1000?

function powerDigitSum(base = 2, exponent = 1000) {
    // JavaScript can't handle 2^1000 as a regular number, so we'll use BigInt
    // BigInt allows us to work with arbitrarily large integers
    
    const power = BigInt(base) ** BigInt(exponent);
    
    // Convert to string to iterate through digits
    const digits = power.toString();
    
    // Sum all the digits
    let sum = 0;
    for (let digit of digits) {
        sum += parseInt(digit);
    }
    
    return sum;
}

// Alternative approach using array-based multiplication for educational purposes
function powerDigitSumManual(base = 2, exponent = 1000) {
    // Start with 1 stored as an array of digits
    let digits = [1];
    
    // Multiply by base, exponent times
    for (let i = 0; i < exponent; i++) {
        let carry = 0;
        
        // Multiply each digit by base
        for (let j = 0; j < digits.length; j++) {
            const product = digits[j] * base + carry;
            digits[j] = product % 10;
            carry = Math.floor(product / 10);
        }
        
        // Add remaining carry digits
        while (carry > 0) {
            digits.push(carry % 10);
            carry = Math.floor(carry / 10);
        }
    }
    
    // Sum all digits
    return digits.reduce((sum, digit) => sum + digit, 0);
}

function solution() {
    console.log('Project Euler Problem 16: Power digit sum');
    console.log('=========================================\n');
    
    // Test with smaller example from problem statement
    const test = powerDigitSum(2, 15);
    console.log(`Test: 2^15 = 32768, digit sum = ${test}`);
    console.log(`Expected: 26, ${test === 26 ? '✓ PASS' : '✗ FAIL'}\n`);
    
    // Solve the actual problem
    console.log('Calculating 2^1000...');
    const result = powerDigitSum(2, 1000);
    console.log(`Sum of digits of 2^1000 = ${result}`);
    
    // Verify with manual approach
    const resultManual = powerDigitSumManual(2, 1000);
    console.log(`Manual calculation: ${resultManual}`);
    console.log(`Results match: ${result === resultManual ? '✓' : '✗'}`);
    
    return result;
}

// Additional exploration: test with different bases and exponents
function explore() {
    console.log('\n\n=== Exploring Power Digit Sums ===\n');
    
    const tests = [
        { base: 2, exp: 10 },
        { base: 2, exp: 100 },
        { base: 3, exp: 100 },
        { base: 10, exp: 100 },
    ];
    
    tests.forEach(({ base, exp }) => {
        const sum = powerDigitSum(base, exp);
        const power = BigInt(base) ** BigInt(exp);
        const numDigits = power.toString().length;
        console.log(`${base}^${exp}: ${numDigits} digits, digit sum = ${sum}`);
    });
}

// Run the solution
console.log(solution());

// Uncomment to explore more
// explore();

module.exports = { powerDigitSum, powerDigitSumManual };










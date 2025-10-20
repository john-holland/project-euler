// Project Euler Problem 16: Power digit sum
// 2^15 = 32768 and the sum of its digits is 3 + 2 + 7 + 6 + 8 = 26.
// What is the sum of the digits of the number 2^1000?

function powerDigitSum(base = 2, exponent = 1000) {
    
    return sum;
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


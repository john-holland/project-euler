function findPythagoreanTriplet(sum = 1000) {
    // For a Pythagorean triplet: a² + b² = c² and a + b + c = 1000
    // We can solve: a + b + c = 1000 and a² + b² = c²
    // This gives us: c = 1000 - a - b
    // And: a² + b² = (1000 - a - b)²
    
    for (let a = 1; a < sum / 3; a++) {
        for (let b = a + 1; b < (sum - a) / 2; b++) {
            const c = sum - a - b;
            
            // Check if it's a Pythagorean triplet
            if (a * a + b * b === c * c) {
                console.log(`Found triplet: a=${a}, b=${b}, c=${c}`);
                console.log(`a + b + c = ${a + b + c}`);
                console.log(`a² + b² = ${a*a + b*b}, c² = ${c*c}`);
                return a * b * c;
            }
        }
    }
    return null;
}

function solution() {
    return findPythagoreanTriplet();
}

console.log(solution());
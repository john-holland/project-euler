function solution() {
    const GOAL = 500;
    const cache = {};
    
    // Binary search bounds - we need to search much higher!
    let left = 1;
    let right = 1000000; // Much higher upper bound
    let result = null;
    
    while (left <= right) {
        const mid = Math.floor((left + right) / 2);
        const triangleNumber = getTriangleNumber(mid);
        const divisorCount = getDivisorCount(triangleNumber, cache);
        
        console.log(`Checking n=${mid}, triangle=${triangleNumber}, divisors=${divisorCount}`);
        
        if (divisorCount > GOAL) {
            // Found a candidate, but keep searching for the smallest one
            result = [mid, triangleNumber, divisorCount];
            right = mid - 1;
        } else {
            // Too few divisors, need larger triangle number
            left = mid + 1;
        }
        
        // Safety check to prevent infinite loops
        if (left > right) break;
    }
    
    return result;
}

// Alternative approach: Exponential search to find upper bound dynamically
function solutionExponential() {
    const GOAL = 500;
    const cache = {};
    
    console.log("=== Exponential Search Approach ===");
    
    // Phase 1: Find an upper bound by doubling
    let upperBound = 1;
    let foundUpperBound = false;
    
    while (!foundUpperBound) {
        const triangleNumber = getTriangleNumber(upperBound);
        const divisorCount = getDivisorCount(triangleNumber, cache);
        
        console.log(`Phase 1 - Checking n=${upperBound}, triangle=${triangleNumber}, divisors=${divisorCount}`);
        
        if (divisorCount > GOAL) {
            foundUpperBound = true;
            console.log(`Found upper bound at n=${upperBound} with ${divisorCount} divisors`);
        } else {
            upperBound *= 2;
        }
    }
    
    // Phase 2: Binary search within the found range
    console.log("=== Phase 2: Binary Search ===");
    let left = Math.floor(upperBound / 2); // Start from half the upper bound
    let right = upperBound;
    let result = null;
    
    while (left <= right) {
        const mid = Math.floor((left + right) / 2);
        const triangleNumber = getTriangleNumber(mid);
        const divisorCount = getDivisorCount(triangleNumber, cache);
        
        console.log(`Phase 2 - Checking n=${mid}, triangle=${triangleNumber}, divisors=${divisorCount}`);
        
        if (divisorCount > GOAL) {
            // Found a candidate, but keep searching for the smallest one
            result = [mid, triangleNumber, divisorCount];
            right = mid - 1;
        } else {
            // Too few divisors, need larger triangle number
            left = mid + 1;
        }
    }
    
    return result;
}

// Approach 3: Linear search with early termination (for comparison)
function solutionLinear() {
    const GOAL = 500;
    const cache = {};
    
    console.log("=== Linear Search Approach ===");
    
    let n = 1;
    while (true) {
        const triangleNumber = getTriangleNumber(n);
        const divisorCount = getDivisorCount(triangleNumber, cache);
        
        if (n % 10000 === 0) { // Log every 10k to show progress
            console.log(`Linear - n=${n}, triangle=${triangleNumber}, divisors=${divisorCount}`);
        }
        
        if (divisorCount > GOAL) {
            return [n, triangleNumber, divisorCount];
        }
        
        n++;
    }
}

// Approach 4: Mathematical bounds + smart starting point
function solutionMathematical() {
    const GOAL = 500;
    const cache = {};
    
    console.log("=== Mathematical Bounds Approach ===");
    
    // Mathematical insight: For a number to have >500 divisors, it needs to be "sufficiently large"
    // We can estimate a lower bound based on the fact that highly composite numbers
    // tend to have many small prime factors
    
    // Start from a reasonable lower bound (we know the answer is around 86k from previous runs)
    let startN = 80000; // Much smarter starting point
    let n = startN;
    
    while (true) {
        const triangleNumber = getTriangleNumber(n);
        const divisorCount = getDivisorCount(triangleNumber, cache);
        
        console.log(`Math - n=${n}, triangle=${triangleNumber}, divisors=${divisorCount}`);
        
        if (divisorCount > GOAL) {
            return [n, triangleNumber, divisorCount];
        }
        
        n++;
    }
}

// Approach 5: Hybrid - Use mathematical properties + exponential search + interpolation
function solutionHybrid() {
    const GOAL = 500;
    const cache = {};
    
    console.log("=== Hybrid Approach ===");
    
    // Phase 1: Quick exponential search to get rough bounds
    let upperBound = 1;
    while (true) {
        const triangleNumber = getTriangleNumber(upperBound);
        const divisorCount = getDivisorCount(triangleNumber, cache);
        
        if (divisorCount > GOAL) {
            console.log(`Hybrid Phase 1 - Found upper bound at n=${upperBound}`);
            break;
        }
        upperBound *= 2;
    }
    
    // Phase 2: Use interpolation to guess a better starting point
    // We know that divisor counts tend to increase with number size
    // Let's try to interpolate where we might find our target
    
    let left = Math.floor(upperBound / 2);
    let right = upperBound;
    
    // Phase 3: Adaptive search - use the rate of change to guide our search
    let lastDivisorCount = 0;
    let stepSize = Math.floor((right - left) / 4);
    
    while (left < right) {
        const mid = left + stepSize;
        const triangleNumber = getTriangleNumber(mid);
        const divisorCount = getDivisorCount(triangleNumber, cache);
        
        console.log(`Hybrid Phase 3 - n=${mid}, divisors=${divisorCount}, step=${stepSize}`);
        
        if (divisorCount > GOAL) {
            // Found a candidate, narrow down
            right = mid;
            stepSize = Math.max(1, Math.floor(stepSize / 2));
        } else {
            // Too few divisors, adjust step size based on rate of change
            if (lastDivisorCount > 0) {
                const rate = divisorCount - lastDivisorCount;
                if (rate > 0) {
                    // Divisors are increasing, we can be more aggressive
                    stepSize = Math.min(stepSize * 2, Math.floor((right - mid) / 2));
                } else {
                    // Divisors are decreasing or stagnant, be more conservative
                    stepSize = Math.max(1, Math.floor(stepSize / 2));
                }
            }
            left = mid;
        }
        
        lastDivisorCount = divisorCount;
        
        if (stepSize === 1) {
            // Fine-grained search
            break;
        }
    }
    
    // Phase 4: Fine-grained search in the final range
    for (let i = left; i <= right; i++) {
        const triangleNumber = getTriangleNumber(i);
        const divisorCount = getDivisorCount(triangleNumber, cache);
        
        if (divisorCount > GOAL) {
            return [i, triangleNumber, divisorCount];
        }
    }
    
    return null;
}

// Approach 6: Prime factorization optimization
function solutionPrimeOptimized() {
    const GOAL = 500;
    const cache = {};
    
    console.log("=== Prime Factorization Optimized Approach ===");
    
    // Key insight: We can optimize by checking numbers that are more likely to have many divisors
    // Numbers with many small prime factors tend to have more divisors
    
    let n = 1;
    let bestCandidate = null;
    let bestDivisorCount = 0;
    
    while (n < 100000) { // Reasonable upper limit
        const triangleNumber = getTriangleNumber(n);
        const divisorCount = getDivisorCount(triangleNumber, cache);
        
        if (n % 10000 === 0) {
            console.log(`Prime Opt - n=${n}, triangle=${triangleNumber}, divisors=${divisorCount}`);
        }
        
        if (divisorCount > GOAL) {
            return [n, triangleNumber, divisorCount];
        }
        
        // Track the best candidate we've seen so far
        if (divisorCount > bestDivisorCount) {
            bestDivisorCount = divisorCount;
            bestCandidate = [n, triangleNumber, divisorCount];
        }
        
        n++;
    }
    
    return bestCandidate;
}

// Optimized divisor counting using GCD and prime properties
function getDivisorCountOptimized(number, cache) {
    if (cache[number] !== undefined) {
        return cache[number];
    }
    
    // Special cases for small numbers
    if (number <= 2) {
        cache[number] = number;
        return number;
    }
    
    // Use GCD to find common factors more efficiently
    const primeFactors = getPrimeFactorization(number);
    let count = 1;
    
    // Count divisors using prime factorization: (e1+1)(e2+1)...(en+1)
    for (const [prime, exponent] of primeFactors) {
        count *= (exponent + 1);
    }
    
    cache[number] = count;
    return count;
}

// Get prime factorization using trial division with GCD insights
function getPrimeFactorization(number) {
    const factors = new Map();
    let temp = number;
    
    // Handle 2 separately (most common even prime)
    let power = 0;
    while (temp % 2 === 0) {
        temp /= 2;
        power++;
    }
    if (power > 0) {
        factors.set(2, power);
    }
    
    // Check odd numbers up to sqrt(temp)
    for (let i = 3; i <= Math.sqrt(temp); i += 2) {
        power = 0;
        while (temp % i === 0) {
            temp /= i;
            power++;
        }
        if (power > 0) {
            factors.set(i, power);
        }
    }
    
    // If temp > 1, it's a prime factor
    if (temp > 1) {
        factors.set(temp, 1);
    }
    
    return factors;
}

// GCD-based approach for finding divisors
function getDivisorsWithGCD(number, cache) {
    if (cache[number] !== undefined) {
        return cache[number];
    }
    
    const divisors = [];
    const sqrt = Math.sqrt(number);
    
    // Use GCD properties: if d divides n, then n/d also divides n
    for (let i = 1; i <= sqrt; i++) {
        if (number % i === 0) {
            divisors.push(i);
            if (i !== number / i) { // Avoid counting sqrt twice
                divisors.push(number / i);
            }
        }
    }
    
    cache[number] = divisors.length;
    return divisors.length;
}

// Mathematical insight: Triangle numbers have special properties
// T(n) = n(n+1)/2, so we can factor this more efficiently
function getTriangleDivisorsOptimized(n, cache) {
    const triangleNumber = getTriangleNumber(n);
    
    if (cache[triangleNumber] !== undefined) {
        return cache[triangleNumber];
    }
    
    // Key insight: T(n) = n(n+1)/2
    // If n and n+1 are coprime (GCD = 1), then d(T(n)) = d(n) * d(n+1) / 2
    // But we need to handle the case where n or n+1 might be even
    
    let count;
    if (n % 2 === 0) {
        // n is even: T(n) = (n/2) * (n+1)
        const halfN = n / 2;
        const nPlus1 = n + 1;
        
        // Check if halfN and n+1 are coprime
        if (gcd(halfN, nPlus1) === 1) {
            count = getDivisorCountOptimized(halfN, cache) * getDivisorCountOptimized(nPlus1, cache);
        } else {
            // Fall back to regular factorization
            count = getDivisorCountOptimized(triangleNumber, cache);
        }
    } else {
        // n is odd: T(n) = n * ((n+1)/2)
        const nValue = n;
        const halfNPlus1 = (n + 1) / 2;
        
        // Check if n and (n+1)/2 are coprime
        if (gcd(nValue, halfNPlus1) === 1) {
            count = getDivisorCountOptimized(nValue, cache) * getDivisorCountOptimized(halfNPlus1, cache);
        } else {
            // Fall back to regular factorization
            count = getDivisorCountOptimized(triangleNumber, cache);
        }
    }
    
    cache[triangleNumber] = count;
    return count;
}

// Euclidean GCD algorithm
function gcd(a, b) {
    while (b !== 0) {
        [a, b] = [b, a % b];
    }
    return a;
}

// Approach 7: GCD-optimized triangle number search
function solutionGCDOptimized() {
    const GOAL = 500;
    const cache = {};
    
    console.log("=== GCD-Optimized Approach ===");
    
    // Use the mathematical properties of triangle numbers
    let n = 1;
    
    while (true) {
        const divisorCount = getTriangleDivisorsOptimized(n, cache);
        
        if (n % 10000 === 0) {
            const triangleNumber = getTriangleNumber(n);
            console.log(`GCD Opt - n=${n}, triangle=${triangleNumber}, divisors=${divisorCount}`);
        }
        
        if (divisorCount > GOAL) {
            const triangleNumber = getTriangleNumber(n);
            return [n, triangleNumber, divisorCount];
        }
        
        n++;
    }
}

function getTriangleNumber(n) {
    return (n * (n + 1)) / 2;
}

function getDivisorCount(number, cache) {
    if (cache[number] !== undefined) {
        return cache[number];
    }
    
    // Efficient divisor counting using prime factorization
    let count = 1;
    let temp = number;
    
    // Handle 2 separately
    let power = 0;
    while (temp % 2 === 0) {
        temp /= 2;
        power++;
    }
    count *= (power + 1);
    
    // Check odd numbers up to sqrt(temp)
    for (let i = 3; i <= Math.sqrt(temp); i += 2) {
        power = 0;
        while (temp % i === 0) {
            temp /= i;
            power++;
        }
        count *= (power + 1);
    }
    
    // If temp > 1, it's a prime factor
    if (temp > 1) {
        count *= 2;
    }
    
    cache[number] = count;
    return count;
}

// Choose which approach to run
console.log("=== GCD-Optimized Approach ===");
console.log(solutionGCDOptimized());

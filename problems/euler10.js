function sumOfPrimes(limit = 2000000) {
    // Use Sieve of Eratosthenes for efficient prime generation
    //assign everything to true,
    // mark initial edge non-primes
    // start at 2 as the limit, since squares are convergences,
    // square index
    // then since square index is the actual, we hop by i (non-square)
    // to mark all non-primes that are multiples of i efficiently
    const sieve = new Array(limit).fill(true);
    sieve[0] = sieve[1] = false;
    
    // Mark non-primes
    for (let i = 2; i * i < limit; i++) {
        if (sieve[i]) {
            // Mark all multiples of i as non-prime
            for (let j = i * i; j < limit; j += i) {
                sieve[j] = false;
            }
        }
    }
    
    // Sum all primes
    let sum = 0;
    for (let i = 2; i < limit; i++) {
        if (sieve[i]) {
            sum += i;
        }
    }
    
    return sum;
}

function solution() {
    return sumOfPrimes();
}

console.log(solution());

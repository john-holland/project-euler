function solution() {
    const triangleNumbers = [];

    let divisors = 1;
    let triangleIndex = 1;
    let cacheDivisors = {};
    const GOAL = 500;

    while (divisors !== 500) {
        let sum = 0;
        for (let i = 1; i <= triangleIndex; i++) {
            sum += i;
        }

        cacheDivisors = getDivisors(sum, cacheDivisors);
        if (cacheDivisors[sum].length === GOAL) {
            return [triangleIndex, sum];
        }
        if (cacheDivisors[sum].length < GOAL) {
            if (Math.abs(cacheDivisors[sum].length - divisors) > 100) {
                triangleIndex *= 2;
            } else {
                triangleIndex++;
            }
        } else if (cacheDivisors[sum].length > GOAL) {
            if (Math.abs(cacheDivisors[sum].length - divisors) > 100) {
                triangleIndex /= 2;
                triangleIndex = Math.floor(triangleIndex);
            } else {
                triangleIndex--;
            }
        }
        divisors = cacheDivisors[sum].length;
        console.log(triangleIndex, sum, divisors);
    }
}

const getDivisors = (number, cache = {}) => {
    // if (gcd + 1 > number) return;  if (number % (gcd + 1) === 0) { cache[gcd + 1] = [...cache[gcd + 1], gcd + 1]; } getDivisors(number, gcd + 1, cache) }
    if (number in cache) return cache[number]
    for (let i = 1; i <= number; i++) {
        if (number % i === 0) {
            if (number in cache) {
                cache[number].push(i)
            } else {
                cache[number] = [i]
            }
        }
    }
    return cache;
}

console.log(solution());

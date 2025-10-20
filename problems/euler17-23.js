// Number Letter Counts
// https://projecteuler.net/problem=17
//
// If the numbers $1$ to $5$ are written out in words: one, two, three, four, five, then there are $3 + 3 + 5 + 4 + 4 = 19$ letters used in total.
// 
// If all the numbers from $1$ to $1000$ (one thousand) inclusive were written out in words, how many letters would be used?
// 
// 
// 
// 
// NOTE: Do not count spaces or hyphens. For example, $342$ (three hundred and forty-two) contains $23$ letters and $115$ (one hundred and fifteen) contains $20$ letters. The use of "and" when writing out numbers is in compliance with British usage.
// NOTE: As an American, the answer is 18551 because you don't create a bunch of fractions, for instance, 300.42 up there...

function solution() {
    // TODO: Implement solution for problem 17
    // sum string length
    // from gemini: Array.from({ length: 1000 }, (v, i) => i + 1)
    let numbers = Array(...Array(1000)).map((n, i) => i + 1);
//    console.log(numbers)
    let respectBritishUsage = true;
    let contraction = respectBritishUsage ? "and" : ""
    const numberMap = [
      {
        digit: 1,
        words: ["", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"],
        wordsTeen: ["ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen", "ten"]
      },
      { 
        digit: 2,
        words: ["", "", "twenty", "thirty", "fourty", "fifty", "sixty", "seventy", "eighty", "ninety", ""]
      },
      { 
        digit: 3,
        words: ["", "onehundred", "twohundred", "threehundred", "fourhundred", "fivehundred", "sixhundred", "sevenhundred", "eighthundred", "ninehundred", ""]
      },
      {
        digit: 4,
        words: ["", "onethousand", "twothousand", "threethousand", "fourthousand", "fivethousand", "sixthousand", "seventhousand", "eightthousand", "ninethousand", ""]
      }
    ]
    // accumulator, current :: a,c
    return numbers.reduce((s, c) => {
      let digits = 1;
      let remainder = c;
      while (Math.floor(remainder / 10) > 0) {
        digits++;
        remainder = remainder / 10;
      }
      /*
        942 % 10
        2
        942 % 100
        42
        Math.floor(942 % 100 / 10)
        4
        (942 - 942 % Math.pow(10, 2)) / Math.pow(10, 2)
        9
        942 % 10
        2
      */
      //112
      //942
      let numberString = "";
      for (let i = digits; i > 0; i--) {
        const secondDigit = Math.floor(c % 100 / 10);
        
        switch (i) {
          case 4:
            numberString += numberMap.find(d => d.digit === 4).words[Math.floor(c - c % 1000) / 1000]
            break;
          case 3:
            numberString += numberMap.find(d => d.digit === 3).words[Math.floor(c - c % 100) / 100]
            break;
          case 2:
            if (digits > 2 && (secondDigit == 0 && c % 10 > 0) || (secondDigi > 0 && c % 10 === 0)) {
              numberString += contraction;
            }
            
            if (secondDigit > 1) {
              numberString += numberMap.find(d => d.digit === 2).words[secondDigit]
            }
            break;
          case 1:
          default:
            if (secondDigit === 1) {
              numberString += numberMap.find(d => d.digit === 1).wordsTeen[Math.floor(c % 10)]
            } else {
              numberString += numberMap.find(d => d.digit === 1).words[Math.floor(c % 10)]
            }
            break;
        }
      }
      if (c > 898) console.log(numberString)
      
      return s + numberString.length;
    }, 0);
}

// Run the solution
console.log(solution());

//module.exports = { solution };

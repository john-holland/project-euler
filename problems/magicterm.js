/* page 148 CACM:

begin integer b, c;
  b := y - x + (n-1) + 2; c := y + y - z;
  if b >= n then b := b - n else if b < 0 then b := b + n;
  if c > n then c  := c - n else if c <= 0 then c := c + n;
  magicterm := b X n + c
end magicterm
*/

/* magic square of set s[1:n, 1:n] generates the magicterm for x, y in set s (theoretically) */

const magicterm = (x, y, n) => {
  let b = y - x + (n - 1) + 2;
  let c = y + y - x;
    if (b >= n) { b = b - n } else if (b < 0) { b = b + n }
    if (c > n) { c = c - n } else if (c <= 0) { c = c + n }
    // cross product??
    return [b * n + c, b, c]
}

for (let i = 0; i < 10; i++) {
  console.log(magicterm(i, i, 10));
}


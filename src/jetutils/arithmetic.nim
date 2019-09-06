proc extgcd*[T:SomeInteger](a, b: T; x, y: var T): T =
  ## Extended GCD 
  if b == 0: 
    x = 1
    y = 0 
    result = a 
  else:
    result = extgcd(b, a mod b, y, x)
    y -= (a div b) * x

proc inv*[T:Positive](n, m: T): T = 
  ## Modulo inverse
  var x: T 
  let g = extgcd(m, n, x, result) 
  assert g == 1, "No multiplicative inverse"
  if unlikely(g < 0): result = -result 
  if unlikely(result < 0): result += m 

proc pow*[T:SomeInteger](x:T, n: Natural): T =
  result = 1
  var
    t = x 
    b = n
  while b > 0: 
    if b mod 2 == 1: 
      result = result * t
    t *= t 
    b = b shr 1

proc pow*[T:SomeInteger](x, n: T, m: Positive): T =
  ## integer power with modulo m
  if n < 0:
    return pow(inv(x,m), -n, m)
      
  result = 1
  var 
    t = x mod m 
    b = n 
  while b > 0: 
    if b mod 2 == 1: 
      result = result * t mod m 
    t = t * t mod m 
    b = b shr 1 

proc fac*[T: Natural](n: T): T = 
  ## Factorial of n. O(n)
  runnableExamples:
    assert fac(3) == 6
  result = 1
  for i in 2..n: result *= i 

proc fac*[T: Natural](n: T, m: Positive): T = 
  ## Factorial of n with modulo m. O(n)
  result = 1
  for i in 2..n: result = result * i mod m

proc binom*[T: Natural](n,r: T): T = 
  ## Binomial O(min(r,n-r))
  runnableExamples:
    assert binom(5,0) == 1
    assert binom(5,1) == 5
    assert binom(5,2) == 10
    assert binom(5,3) == 10
    assert binom(5,4) == 5
    assert binom(5,5) == 1
  if r < 0 or r > n: 
    return 0
  result = 1 
  let t = min(r,n-r)
  for i in 1..t: result = result * (n+1-i) div i 

proc binom*[T: Natural](n,r: T, m: Positive): T = 
  ## Binomial with modulo m. O(min(r,n-r))
  if r < 0 or r > n: 
    return 0
  result = 1 
  let t = min(r,n-r)
  for i in 1..t: result = result * (n+1-i) div i 



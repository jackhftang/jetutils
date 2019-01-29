# This is just an example to get you started. A typical library package
# exports the main API in this file. Note that you cannot rename this file
# but you can remove it if you wish.

proc add*(x, y: int): int =
  ## Adds two files together.
  return x + y

proc bsearch*(x, y: int, pred : proc (mi : int): bool  {.closure.}): (int,int) = 
  result = (x,y) 
  while result[0] + 1 < result[1] : 
    var mi = (result[0] + result[1]) shr 1 
    if pred mi: result[0] = mi 
    else: result[1] = mi

proc bsearchMax*(x, y:int, pred : proc(mi:int) : bool): int = bsearch(x,y,pred)[0]

proc bsearchMin*(x, y:int, pred : proc(mi:int) : bool): int = bsearch(x,y,pred)[1]  

proc sieve*(mx : int): seq[bool] = 
  result = newSeq[bool](mx+1)
  if mx < 2 : return 
  result[1] = false 
  for i in 2..mx:
    result[i] = true 
  for i in 2..mx:
    if result[i]: 
      for j in countup(2*i,mx,i):
        result[j] = false 
  
proc pow*(x, n, m : int) : int =
  result = 1
  var 
    t = x mod m 
    b = n 
  while b > 0: 
    if b mod 2 == 1: 
      result = result * t mod m 
    t = t * t mod m 
    b = b shr 1 

proc rabinMiller*(n : int): bool = 
  if n <= 1: return false 
  
  # n-1 = d*2^s
  var 
    s = 0
    d = n - 1
  while d mod 2 == 0: 
    s += 1
    d = d shr 1 

  proc check(p:int) : bool = 
    var x = pow(p, d, n)
    if x == 1: return false 
    for i in 0 ..< s:
      if x == n - 1: return false 
      x = x * x mod n
    return true 

  # valid up to 318,665,857,834,031,151,167,461 ~= 3.1e23 > 2^64
  let bases = [2,3,5,7,11,13,17,19,23,29,31,37]
  for p in bases:
    if p == n: return true 
    if check p: return false 

  return true

iterator primes() : int = 
  const bases = [2,3,5,7,11,13,17]
  var base = 1 
  for p in bases:
    yield p 
    base *= p 

  let isPrime = sieve base 
  var primes = @[1]
  for i in bases[^1]+2 ..< isPrime.len: 
    if isPrime[i]: 
      yield i
      primes.add i 

  var b = base 
  while true:
    for offset in primes: 
      let t = b + offset 
      if rabinMiller t: 
        yield t
    b += base

when isMainModule: 
  sieve 100
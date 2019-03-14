import arithmetic

proc sieve*(mx: Natural): seq[bool] = 
  ## Return an array x of length mx+1 such that x[i] is true if only only if i is a prime number
  result = newSeq[bool](mx+1)
  if mx < 2 : return 
  for i in 2..mx:
    result[i] = true 
  for i in 2..mx:
    if result[i]: 
      for j in countup(2*i,mx,i):
        result[j] = false 

proc rabinMillerCheck(n,d,s,p: int) : bool = 
  var x = pow(p, d, n)
  if x == 1: return false 
  for i in 0 ..< s:
    if x == n - 1: return false 
    x = x * x mod n
  return true 
  
proc rabinMiller*(n: Natural): bool = 
  ## Fast primality check with bases [2,3,5,7,11,13,17,19,23,29,31,37] which cover whole range of 64-bits integer
  if n <= 1: return false 
  
  # n-1 = d*2^s
  var 
    s = 0
    d = n - 1
  while d mod 2 == 0: 
    s += 1
    d = d shr 1 

  ## valid up to 318,665,857,834,031,151,167,461 ~= 3.1e23 > 2^64
  let bases = [2,3,5,7,11,13,17,19,23,29,31,37]
  for p in bases:
    if p == n: return true 
    if rabinMillerCheck(n,d,s,p) : return false 

  return true
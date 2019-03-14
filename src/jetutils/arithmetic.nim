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
  # todo: support negative value 
  result = 1
  var 
    t = x mod m 
    b = n 
  while b > 0: 
    if b mod 2 == 1: 
      result = result * t mod m 
    t = t * t mod m 
    b = b shr 1 

proc factorial*(n: Natural): int = 
  result = 1
  for i in 2..n: result *= i 

proc factorial*(n: Natural, m: Positive): int = 
  result = 1
  for i in 2..n: result = result * i mod m


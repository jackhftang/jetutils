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

proc sieve*[T](mx : T): seq[T] {.noSideEffect.} = 
  var isPrime = newSeq[bool](mx+1)
  for i in 0..mx:
    isPrime[i] = true 
  isPrime[0] = false 
  isPrime[1] = false 
  for i in 0..mx:
    if isPrime[i]: 
      for j in countup(2*i,mx,i):
        isPrime[j] = false 
  for i in 0..mx:
    if isPrime[i]:
      result.add i 
proc bsearchMax*[T:Ordinal](a, b: T, prediate: proc (mi: T): bool  {.closure.}): T = 
  ## Find the maximum value mx between [a,b) such that `predicate(mx)` is true
  ##
  ## NOTE: It is assumed that `predicate(a)` is always true. In case all values in [a,b) yield false, a is returned.
  var
    lo = ord(a)
    up = ord(b)
  while lo + 1 < up : 
    let mi = (lo + up) shr 1 
    if prediate mi.T: lo = mi 
    else: up = mi
  return lo.T

proc bsearchMin*[T:Ordinal](a, b: T, prediate: proc (mi: T): bool  {.closure.}): T = 
  ## Find the minimum value mi between (a,b] such that `predicate(mi)` is true
  ##
  ## NOTE: It is assumed that `predicate(b)` is always true. In case all values in (a,b] yield false, b is returned.
  var
    lo = ord(a)
    up = ord(b)
  while lo + 1 < up : 
    let mi = (lo + up) shr 1 
    if prediate mi.T: up = mi 
    else: lo = mi
  return up.T

template times*(n:int, body:untyped) = 
  ## repeat block of code N times
  ## Example:
  ##
  ## .. code-block:: nim
  ##  3.times do:
  ##    echo "ho"
  for i in 1..n:
    body

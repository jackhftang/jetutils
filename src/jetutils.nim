# This is just an example to get you started. A typical library package
# exports the main API in this file. Note that you cannot rename this file
# but you can remove it if you wish.

proc add*(x, y: int): int =
  ## Adds two files together.
  return x + y

proc bsearch*(x, y: int, pred : proc (mi : int): bool  {.closure.}): (int,int) = 
  var 
    lo = x 
    up = y
  while lo + 1 < up : 
    var mi : int = (lo+up) shr 1 
    if pred mi: lo = mi 
    else: up = mi 
  return (lo, up)
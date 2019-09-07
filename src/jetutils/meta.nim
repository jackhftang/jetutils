import sequtils 

template vectorize*(T,f: untyped): untyped = 
  ## ..code-block: nim
  ##  proc double(x:int): int = 2*x
  ##  check double([1,2,3]) == @[2,4,6]
  type
    S = typeof(f(new(T)[]))
  proc `f`(xs: openArray[T]): seq[S] =
    result = newSeq[S](xs.len)
    for i,x in xs: result[i] = `f`(x)


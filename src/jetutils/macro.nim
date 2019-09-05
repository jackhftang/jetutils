import sequtils 

template vectorize(f: untyped): untyped = 
  proc `f`[T](x: openArray[T]): seq[T] = x.mapIt(f(it))

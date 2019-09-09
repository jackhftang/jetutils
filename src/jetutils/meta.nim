import sequtils 

template vectorize*(f,T: untyped): untyped = 
  ## make a unary operation applicable over seq[T]
  runnableExamples:
    proc double(x:int): int = 2*x
    vectorize(double, int)
    assert double([1,2,3]) == [2,4,6]
  type
    S = typeof(f(new(T)[]))

  # seq
  proc `f`(xs: seq[T]): seq[S] =
    result.setLen(xs.len)
    for i,x in xs: result[i] = f(x)

  # array 
  proc `f`[I](xs: array[I,T]): array[I,S] = 
    for i, x in xs: result[i] = f(x)

template vectorize*(f,T,S: untyped): untyped =
  ## make a binary operation applicable over (seq[T], seq[S])
  runnableExamples:
    vectorize(`+`,int,int)
    assert [1,2] + [3,4] == @[4,6]
    assert 1 + [2,3] == @[3,4]
    assert [1,2] + 3 == @[4,5]
  runnableExamples:
    vectorize(`+`,int,int)
    vectorize(`*`,int,int)
    let x = [1,2,3]
    assert (1+x) * 4 == 4*x + 4
  type
    outType = typeof(f(new(T)[], new(S)[]))

  # vector-vector
  proc `f`(xs: openArray[T], ys: openArray[S]): seq[outType] =
    let l = xs.len
    if l != ys.len: raise newException(ValueError, "cannot vectorize over unequal length")
    result.setLen(l)
    for i in 0 ..< l: result[i] = f(xs[i], ys[i])

  # vector-scale
  proc `f`(xs: openArray[T], y: S): seq[outType] =
    result.setLen(xs.len)
    for i in 0 ..< xs.len: result[i] = f(xs[i], y)

  # scale-vector
  proc `f`(x: T, ys: openArray[S]): seq[outType] =
    result.setLen(ys.len)
    for i in 0 ..< ys.len: result[i] = f(x, ys[i])
    
template nestedUnary*(f: untyped): untyped = 
  ## operator f must be close i.e. T -> T 

  # seq 
  proc `f`[T](xs: seq[T]): seq[T] = 
    let l = xs.len
    result.setLen(l)
    for i in 0 ..< l: result[i] = f(xs[i])

  # array 
  proc `f`[I,T](xs: array[I,T]): array[I,T] = 
    for i in 0 ..< xs.len: result[i] = f(xs[i])
  

template nestedBinary*(f: untyped): untyped =
  ## operator f must be closed i.e. T -> T -> T

  # seq 
  proc `f`[T](xs: seq[T], ys: seq[T]): seq[T] = 
    let l = xs.len
    if l != ys.len: 
      raise newException(ValueError, "unequal length")
    result.setLen(l)
    for i in 0 ..< l:
      result[i] = f(xs[i],ys[i])

  proc `f`[T](xs: seq[T], y: T): seq[T] = 
    result.setLen(xs.len)
    for i in 0 ..< xs.len:
      result[i] = f(xs[i],y)
  
  proc `f`[T](x: T, ys: seq[T]): seq[T] = 
    result.setLen(ys.len)
    for i in 0 ..< ys.len:
      result[i] = f(x,ys[i])

  # array 
  proc `f`[I,T](xs: array[I,T], ys: array[I,T]): array[I,T] = 
    for i,x in xs:
      result[i] = f(x,ys[i])

  proc `f`[I,T](xs: array[I,T], y: T): array[I,T] = 
    for i,x in xs:
      result[i] = f(x,y)
  
  proc `f`[I,T](x: T, ys: array[I,T]): array[I,T] = 
    for i,y in ys:
      result[i] = f(x,y)
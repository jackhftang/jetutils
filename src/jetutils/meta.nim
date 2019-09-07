import sequtils 

template vectorize*(f,T: untyped): untyped = 
  ## make a unary operation applicable over seq[T]
  runnableExamples:
    proc double(x:int): int = 2*x
    vectorize(double, int)
    assert double([1,2,3]) == @[2,4,6]
  type
    S = typeof(f(new(T)[]))
  proc `f`(xs: openArray[T]): seq[S] =
    result = newSeq[S](xs.len)
    for i,x in xs: result[i] = `f`(x)

template vectorize*(f,T,S: untyped): untyped =
  ## make a binary operation applicable over (seq[T], seq[S])
  runnableExamples:
    vectorize(`+`,int,int)
    assert [1,2] + [3,4] == @[4,6]
  runnableExamples:
    vectorize(`+`,int,int)
    vectorize(`*`,int,int)
    let x = [1,2,3]
    assert (1+x) * 4 == 4 + 4*x
  type
    outType = typeof(f(new(T)[], new(S)[]))
  proc `f`(xs: openArray[T], ys: openArray[S]): seq[outType] =
    let l = xs.len
    if l != ys.len: raise newException(ValueError, "cannot vectorize over unequal length")
    result = newSeq[outType](l)
    for i in 0 ..< l: result[i] = f(xs[i], ys[i])
  proc `f`(xs: openArray[T], y: S): seq[outType] =
    result = newSeq[outType](xs.len)
    for i in 0 ..< xs.len: result[i] = f(xs[i], y)
  proc `f`(x: T, ys: openArray[S]): seq[outType] =
    result = newSeq[outType](ys.len)
    for i in 0 ..< ys.len: result[i] = f(x, ys[i])
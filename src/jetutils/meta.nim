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
  type
    outType = typeof(f(new(T)[], new(S)[]))
  proc `f`(xs: openArray[T], ys: openArray[S]): seq[outType] =
    let l = xs.len
    if l != ys.len: raise newException(ValueError, "cannot vectorize over unequal length")
    result = newSeq[outType](l)
    for i in 0 ..< l: result[i] = f(xs[i], ys[i])
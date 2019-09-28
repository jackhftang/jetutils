import tables

proc cmp*[I,T](a,b: array[I,T]): int =
  for i, x in a:
    let c = cmp(x, b[i])
    if c != 0: return c

proc cmp*[T](a,b: seq[T]): int =
  ## compare elements from left to right until the first unequal, shorter and smaller.
  runnableExamples:
    assert cmp(@[1,2],@[2,1]) == -1
    assert cmp(@[2,1],@[1,2]) == 1
    assert cmp(@[1,2],@[1,2,3]) == -1
    assert cmp(@[1,2,3],@[1,2]) == 1
  let 
    la = a.len
    lb = b.len
  result = 0 
  for i in 0 ..< min(la,lb):
    let c = cmp(a[i], b[i])
    if c != 0: return c
  if la < lb: return -1
  if la > lb: return 1

proc `<`*[I,T](a,b: array[I,T]): bool =
  ## equivalent to `cmp(a,b) < 0`
  cmp(a,b) < 0

proc `<`*[T](a,b: seq[T]): bool = 
  ## equivalent to `cmp(a,b) < 0`
  cmp(a,b) < 0

iterator reverse*[T](arr: openArray[T]): T = 
  ## Reverse iterator 
  runnableExamples:
    var 
      i = 0
      y = [3,2,1]
    for x in [1,2,3].reverse: 
      assert x == y[i]
      inc i 

  var i = arr.high
  while arr.low <= i: 
    yield arr[i] 
    i.dec

proc argmin*[T](arr: openArray[T]): int = 
  ## Find the minimum index of minimum value in an array.
  ## Return -1 if empty.
  if arr.len == 0: return -1 
  var val = arr[0]
  for i in 1..arr.high:
    if arr[i] < val:
      result = i 
      val = arr[i] 

proc argmins*[T](arr: openArray[T]): seq[int] = 
  ## Find all index of minimum value in an array.
  if arr.len == 0: return @[]
  var val = arr[0]
  result = @[0]
  for i in 1..arr.high:
    if arr[i] < val:
      result = @[i]
      val = arr[i] 
    elif arr[i] == val:
      result.add i

proc argmax*[T](arr: openArray[T]): int = 
  ## Find the minimum index of maximum value in an array.
  ## Return -1 if empty. 
  if arr.len == 0: return -1 
  var val = arr[0]
  for i in 1..arr.high:
    if arr[i] > val:
      result = i 
      val = arr[i] 

proc argmaxs*[T](arr: openArray[T]): seq[int] = 
  ## Find all index of maximum value in an array.
  if arr.len == 0: return @[]
  var val = arr[0]
  result = @[0]
  for i in 1..arr.high:
    if arr[i] > val:
      result = @[i] 
      val = arr[i]
    elif arr[i] == val:
      result.add i

proc position*[T](arr: openArray[T], e: T): int =
  ## find the minimum index of e in arr
  result = -1 
  for i, x in arr: 
    if x == e:
      result = i
      break

proc positions*[T](arr: openArray[T], e: T): seq[int] =
  ## find all index of e in arr
  for i, x in arr:
    if x == e:
      result.add i

proc groupBy*[T,S](arr: openArray[S], group: proc(x:S): T): TableRef[T,seq[S]] = 
  ## classify the element of type T by group function S -> T and return a table mapping T to seq[S]
  runnableExamples:
    import tables
    let x = [1,2,3,4,5]
    let y = x.groupBy proc(x:int): string = 
      if x mod 2 == 0: result = "even"
      else: result = "odd"
    assert y[] == { "even": @[2,4], "odd": @[1,3,5] }.toTable
  result = newTable[T,seq[S]](rightSize(arr.len))
  for x in arr:
    let g = group(x)
    if result.contains g: result[g].add(x)
    else: result[g] = @[x]

proc liftSeq*[T,S](f: proc (x: T): S {.closure.}): proc(xs: seq[T]): seq[S] =
  ## lift a function over seq
  runnableExamples:
    template `|>`(x, f : untyped): untyped = f(x)
    proc double(x: int): int = 2*x
    let y = @[1,2,3] |> liftSeq double
    assert y == @[2,4,6]
  runnableExamples:
    template `|>`(x, f : untyped): untyped = f(x)
    proc double(x:int): int = 2*x 
    let y = @[@[1,2,3], @[4,5]] |> liftSeq (liftSeq double)
    assert y == @[@[2, 4, 6], @[8, 10]]
  result = proc (xs: seq[T]): seq[S] = 
    for x in xs: result.add(f(x))
  
proc map*[T](xs: openArray[T], f: proc(i: int, x: T): T): seq[T] = 
  result.setLen(xs.len)
  for i in 0 ..< result.len: 
    result[i] = f(i,xs[i])

proc each*[T](xs: openArray[T], f: proc(x: T)) =
  ## similar to for statement, but accept a procedure
  runnableExamples:
    var i = 1
    [1,2,3].each proc (x:int) =
      assert x == i
      inc i
  for x in xs: f(x) 

proc each*[T](xs: openArray[T], f: proc(i: int, x: T)): void = 
  for i in 0 ..< xs.len: f(i,xs[i])

template eachIt*(xs: typed, f: untyped) =
  runnableExamples:
    var i = 0
    (..10).eachIt: 
      assert it == i
      inc i
  for it {.inject.} in xs: f 

proc newSeq*[T](length: int, f: proc(i:int): T): seq[T] = 
  ## create a new Seq[T] with initialization 
  runnableExamples:
    let s = newSeq(3, proc(i:int): int = i)
    assert s == @[0,1,2]
  result.setLen(length)
  for i in 0 ..< length: result[i] = f(i)

proc summation*[T](xs: openArray[T]): T =
  runnableExamples:
    assert summation([1,2,3]) == 6
  for x in xs: result += x

proc first*[T](xs: openArray[T]): T = xs[0]

proc last*[T](xs: openArray[T]): T = xs[^1]

proc fold*[T,S](xs: openArray[T], init: S, f: proc(a: S, b: T): S): S =
  runnableExamples:
    import sugar
    let y = [1,2,3].fold(0, (a,b) => a+b)
    assert y == 6
  result = init
  for x in xs: result = f(result, x)

proc unroll*[T,S](xs: openArray[T], init: S, f: proc(a,b: T): S): seq[S] = 
  runnableExamples:
    import sugar
    let y = [1,2,3].unroll(0, (a,b) => a+b)
    assert y == @[0,1,3,6]
  result = newSeq[int](xs.len + 1)
  result[0] = init
  for i, x in xs: result[i+1] = f(result[i], x)
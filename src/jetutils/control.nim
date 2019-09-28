import macros

template bsearchMaxIt*(a, b: typed, code: untyped): untyped = 
  type outType = type(a)
  var
    lo = ord(a)
    up = ord(b)
  while lo + 1 < up : 
    let mi = (lo + up) shr 1
    let it {.inject.} = outType(mi)
    if code : lo = mi
    else: up = mi
  outType(lo)

proc bsearchMax*[T:Ordinal](a, b: T, predicate: proc (mi: T): bool  {.closure.}): T = 
  ## Find the maximum value mx between [a,b) such that `predicate(mx)` is true
  ##
  ## NOTE: It is assumed that `predicate(a)` is always true. In case all values in [a+1,b] yield false, a is returned.
  bsearchMaxIt(a,b,predicate it)

template bsearchMinIt*(a, b: typed, code: untyped): untyped = 
  type outType = type(a)
  var
    lo = ord(a)
    up = ord(b)
  while lo + 1 < up : 
    let mi = (lo + up) shr 1
    let it {.inject.} = outType(mi)
    if code : up = mi
    else: lo = mi
  outType(up)

proc bsearchMin*[T:Ordinal](a, b: T, predicate: proc (mi: T): bool  {.closure.}): T = 
  ## Find the minimum value mi between (a,b] such that `predicate(mi)` is true
  ##
  ## NOTE: It is assumed that `predicate(b)` is always true. In case all values in [a,b-1] yield false, b is returned.
  bsearchMinIt(a,b,predicate it)

template times*(n:int, body:untyped) = 
  ## Repeat block of code N times, can `break` earlier.
  runnableExamples:
    var i = 0 
    3.times:
      if i == 2: break
      inc i
    assert i == 2
  for i in 1..n:
    body

template forever*(body: untyped) = 
  ## loop forever, can `break`.
  runnableExamples:
    var i = 0
    forever:
      if i == 5: break
      inc i
    assert i == 5
  while true:
    body

iterator `..<`*[T](b: T): T =
  ## Only high part need to be specified, low part is T(0) 
  runnableExamples:
    let arr = [1,2,3]
    var sum = 0
    for i in ..< arr.len: 
      sum += arr[i]
    assert sum == 6
  var i = T(0)
  while i < b:
    yield i
    inc i

macro forSum*(args: varargs[untyped]): untyped = 
  ## transform to a serial of  `for` statement 
  ##
  ## ..code-block: nim
  ##  forSum i in 1..10, "abcd": 
  ##    echo i 
  ## 
  ## equivalent to 
  ## 
  ## ..code-block: nim 
  ##  for i in 1..10:
  ##    echo i 
  ##  for i in "abcd":
  ##    echo i

  # deal with the in operator 
  expectKind(args[0], nnkInfix)
  expectLen(args[0], 3) 
  assert args[0][0].strVal == "in"
  expectKind(args[0][1], nnkIdent)

  let ident = args[0][1] 
  var iterators = @[args[0][2]]

  # get iterators
  for i in 1 .. args.len-2:
    iterators.add(args[i])
  
  # code 
  let code = args[args.len-1]

  # generate code 
  result = newStmtList()
  for it in iterators:
    var t = newNimNode(nnkForStmt)
    t.add(ident)
    t.add(it)
    t.add(copyNimTree(code))
    result.add(t)

macro forProd*(args: varargs[untyped]): untyped = 
  ## Transform to nested `for` statement 
  ## 
  ## Example:
  ## 
  ## ..code-block: nim
  ##  forProd i,j,k in 1..10, "abc", [false, true]:
  ##    echo i, " ", j, " ", k 
  ## 
  ## transform to
  ## 
  ## ..code-block: nim 
  ##  for i in 1..10:
  ##    for j in "abc":
  ##      for k in [false, true]:
  ##        echo i, " ", j, " ", k 
  ##

  var i = 0
  var idents : seq[NimNode] = @[]
    
  # number of argument must be odd number 
  assert args.len mod 2 == 0, "number of identifiers must equal to number of iterators"
  var n = args.len div 2 

  # get identifiers 
  while i < args.len: 
    # echo args[i].kind
    let node = args[i]
    if node.kind == nnkIdent:
      idents.add(node)
      i.inc
    else:
      break 
  assert idents.len == n-1, "too many identifiers"

  # deal with the in operator 
  expectKind(args[i], nnkInfix)
  expectLen(args[i], 3)
  assert args[i][0].strVal == "in"
  expectKind(args[i][1], nnkIdent)
  idents.add(args[i][1])

  # get iterators
  var iterators = @[args[i][2]]
  i.inc 
  while i < args.len - 1:
    iterators.add(args[i])
    i.inc 
  
  # code 
  let code = args[i]

  # generate code 
  var forStmt = newNimNode(nnkForStmt)
  forStmt.add(idents[n-1])
  forStmt.add(iterators[n-1])
  forStmt.add(code)
  for i in countdown(n-2,0):
    let t = newNimNode(nnkForStmt)
    t.add(idents[i])
    t.add(iterators[i])
    t.add(forStmt)
    forStmt = t 
    
  result = forStmt

macro forZip*(args: varargs[untyped]): untyped = 
  ## Each iterators need to have len() implementation
  ## 
  ## Example:
  ## 
  ## ..code-block: nim
  ##  forZip i,j in [1,2,3], "abc":
  ##    echo i, j
  ## 
  ## transform to
  ## 
  ## ..code-block: nim 
  ##  block: 
  ##    let 
  ##      l = min(ident1.len,ident2.len)
  ##      lis1 = [1,2,3]
  ##      lis2 = "abc"
  ##    for ix in 0 ..< l:
  ##      let i = sym1[ix]
  ##      let j = sym2[ix]
  ##      echo i, j
  ##      
  var i = 0
  var idents : seq[NimNode] = @[]
    
  # number of argument must be odd number 
  assert args.len mod 2 == 0, "number of identifiers must equal to number of lists"
  var n = args.len div 2 

  # get identifiers 
  while i < args.len: 
    # echo args[i].kind
    let node = args[i]
    if node.kind == nnkIdent:
      idents.add(node)
      i.inc
    else:
      break 
  assert idents.len == n-1, "too many identifiers"

  # deal with the in operator 
  expectKind(args[i], nnkInfix)
  expectLen(args[i], 3) 
  assert args[i][0].strVal == "in"
  expectKind(args[i][1], nnkIdent)
  idents.add(args[i][1])

  # get iterators
  var lists = @[args[i][2]]
  i.inc 
  while i < args.len - 1:
    lists.add(args[i])
    i.inc 
  
  # code 
  let code = args[i]

  # generate code 
  let stmts = newStmtList()

  # let statements 
  var symLists: seq[NimNode] = @[]
  for it in lists:
    let sym = genSym()
    symLists.add sym
    stmts.add newLetStmt(sym, it)

  # minimum length among lists
  let symMin = genSym()
  var minExpr = newCall(ident("len"), symLists[0])
  for i in 1..<symLists.len:
    minExpr = newCall(ident("min"), newCall(ident("len"), symLists[i]), minExpr)
  stmts.add newLetStmt(symMin, minExpr)

  # for loop 
  var symIx = genSym(nskForVar)
  var forStmt = newNimNode(nnkForStmt)
    .add(symIx)
    .add(newNimNode(nnkInfix).add(ident "..<").add(newIntLitNode(0), symMin))

  # for loop body
  let body = newStmtList()
  for i, ident in idents: 
    body.add newLetStmt(ident, newNimNode(nnkBracketExpr).add(symLists[i]).add(symIx))
  body.add code
  forStmt.add body

  stmts.add forStmt
  result = newBlockStmt(stmts)
  
template forIt*(xs: untyped, body: untyped): untyped = 
  ## iterate over xs with default variable named `it`
  ## forIt can be nested and break early.
  runnableExamples:
    var i = 0
    forIt ..10:
      if it > 5: break
      i += 1
    assert i == 6
  runnableExamples:
    forIt 'a'..'c':
      assert it is char
      (1..3).forIt:
        assert it is int
  for it {.inject.} in xs: body


# TODO: not useful for nim, because it could be just x.f 
macro `|>`*(x, f : untyped): untyped = 
  ## infix operator of function application f(x)
  runnableExamples:
    proc double(x:int): int = 2*x
    let x = 3 
    assert x |> double |> double == double(double(x))
  newCall(f,x)

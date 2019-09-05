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
  ## NOTE: It is assumed that `predicate(a)` is always true. In case all values in [a,b) yield false, a is returned.
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
  ## NOTE: It is assumed that `predicate(b)` is always true. In case all values in (a,b] yield false, b is returned.
  bsearchMinIt(a,b,predicate it)

template times*(n:int, body:untyped) = 
  ## Repeat block of code N times.
  ## Example:
  ##
  ## .. code-block:: nim
  ##  3.times:
  ##    echo "ho"
  for i in 1..n:
    body

iterator `..<`*[T](b: T): T =
  ## Only high part need to be specified 
  ## 
  ## .. code-block:: nim 
  ##  for i in ..< arr.len: 
  ##    echo arr[i]
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
  assert args[i].kind == nnkInfix
  assert args[i].len == 3 
  assert args[i][0].strVal == "in"
  assert args[i][1].kind == nnkIdent
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
  ##  forMin i,j in [1,2,3], "abc":
  ##    echo i, j
  ## 
  ## transform to
  ## 
  ## ..code-block: nim 
  ##  block: 
  ##    let sym1 = [1,2,3]
  ##    let sym2 = "abc"
  ##    let sym3 = min(ident1.len,ident2.len)
  ##    for sym4 in 0 ..< sym3:
  ##      let i = sym1[ident4]
  ##      let j = sym2[ident4]
  ##      echo i, j
  ##      
  ## symbols (sym1,sym2,sym3,sym4) are uniquely generated
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
  assert args[i].kind == nnkInfix
  assert args[i].len == 3 
  assert args[i][0].strVal == "in"
  assert args[i][1].kind == nnkIdent
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
  
template forIt*(xs: typed, body: untyped): untyped = 
  ## iterate over xs with default variable named `it`
  runnableExamples:
    var i = 0
    (..10).forIt: 
      assert it == i
      inc i
  for it {.inject.} in xs: body

macro `|>`*(x, f : untyped): untyped = 
  ## infix operator of function application f(x)
  newCall(f,x)

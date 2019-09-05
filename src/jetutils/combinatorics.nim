iterator combination*(m, n: int): seq[int] =
  var c = newSeq[int](n)
  for i in 0 ..< n: c[i] = i
 
  block outer:
    while true:
      yield c

      # leaf: increase until overflow
      inc c[^1]
      if c[^1] <= m - 1: continue

      # rewind: seek to non-max position
      var i = n - 1
      while c[i] >= m - n + i:
        dec i
        if i < 0: break outer

      # down: reset to leaf
      inc c[i]
      for j in i+1 ..< n: c[j] = c[j-1] + 1 
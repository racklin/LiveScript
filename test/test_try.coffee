# Basic exception throwing.
throws 'up', -> throw Error 'up'


# Basic try/catch.
eq 5, try throw 'error' catch e then e.length

eq 2, try
  throw 'up'
catch e
  e.length

eq 1, try
  throw o = i: 0
catch e
  ++e.i
finally
  ++o.i
eq o.i, 2


# try/catch with empty clauses still compiles.
try

try
finally

try
  # nothing
finally
  # nothing

eq 99, do -> try 99

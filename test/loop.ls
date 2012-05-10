i = 5
list = while i -= 1
  i * 2
eq '' + list, '8,6,4,2'

i = 5
list = (i * 3 while i -= 1)
eq '' + list, '12,9,6,3'

i = 5
func   = -> i -= it
assert = -> ok false unless 0 < i < 5
results = while func 1
  assert()
  i
eq '' + results, '4,3,2,1'

value = false
i = 0
results = until value
  value = true if i is 5
  i += 1

ok i is 6


i = 5
list = []
for ever
  i -= 1
  break if i is 0
  list.push i * 2

ok list.join(' ') is '8 6 4 2'

j = 5
list2 = []
loop
  j -= 1
  break if j is 0
  list2.push j * 2

ok list2.join(' ') is '8 6 4 2'

#759: `if` within `while` condition
2 while if 1 then 0


# https://github.com/jashkenas/coffee-script/issues/843
eq void, do -> return while 0


# Basic array comprehensions.
nums    = for n in [1, 2, 3] then n * n if n &&& 1
results = (n * 2 for n in nums)

eq results + '', '2,18'


# Basic object comprehensions.
obj   = {one: 1, two: 2, three: 3}
names = (prop + '!' for prop of obj)
odds  = for prop, value of obj then prop + '!' if value &&& 1

eq names.join(' '), 'one! two! three!'
eq odds. join(' '), 'one! three!'


# Basic range comprehensions.
nums = (i * 3 for i from 1 to 3)
negs = (x for x from -20 to -5*2)
four = (4 for x to 3)
eq '3,6,9,-20,-19,-18,4,4,4,4', '' + nums.concat negs.slice(0, 3), four

eq '123', (i for i from 1 til 4     ).join ''
eq '036', (i for i from 0 til 9 by 3).join ''

# Never mess with binary `in`/`of` and variable `by`.
for i to 0
  ok 0 of [0]
  ok 0 in [0]
  ok by = true

by for by in [1]; ok by
by for by til 1
ok by


# With range comprehensions, you can loop in steps.
eq "#{ x for x from 0 to 9 by  3 }", '0,3,6,9'
eq "#{ x for x from 9 to 0 by -3 }", '9,6,3,0'
eq "#{ x for x from 3*3 to 0*0 by 0-3 }", '9,6,3,0'


# Multiline array comprehension with filter.
evens =
  for num in [1, 2, 3, 4, 5, 6] then if num % 2 is 0
    num *= -1
    num -=  2
    num * -1
eq evens + '', '4,6,8'


# Backward traversing.
odds = (num for num in [0, 1, 2, 3, 4, 5] by -2)
eq odds + '', '5,3,1'


# all/from/to/by aren't reserved off-context.
all = from = to = by = 1


# Nested comprehensions.
multiLiner =
  for x from 3 to 5
    for y from 3 to 5
      x * y

singleLiner = (x * y for y from 3 to 5 for x from 3 to 5)

eq multiLiner.length, singleLiner.length
eq 25,  multiLiner[*-1]
eq 25, singleLiner[*-1]


# Comprehensions within parentheses.
result = null
store = -> result := it
store (x * 2 for x in [3, 2, 1])

ok result.join(' ') is '6 4 2'


# Closure-wrapped comprehensions that refer to the "arguments" object.
expr = ->
  result = (item * item for item in arguments)

ok expr(2, 4, 8).join(' ') is '4 16 64'


# Fast object comprehensions over all properties, including prototypal ones.
class Cat
  -> @name = 'Whiskers'
  breed: 'tabby'
  hair:  'cream'

whiskers = new Cat
own = (value for own key, value of whiskers)
all = (value for key, value of whiskers)

ok own.join(' ') is 'Whiskers'
ok all.sort().join(' ') is 'Whiskers cream tabby'


f = -> [-> ok false, 'should cache source']
ok true for k of [f] = f()


# Allow non-last lines to have `continue` or `break`.
func = ->
  for i from 1 to 2
    break if i is 2
    i * j for j in [3]
eq func()[0], 3

i = 6
odds = while i--
  continue unless i &&& 1
  i
eq '5,3,1', '' + odds

r = for i from 0 to 2
  switch i
  case 0 then continue
  case 1 then i
  default break
eq r + '', '1'

eq (while 1 then break; 1).length, 0


copy = {}
continue for k, copy[k] of [4, 2]
eq copy.0 * copy.1, 8


new -> do ~>
  me = this
  [] = for ever
    eq me, this
    eq me, do ~> this
    break
    1


throws    'stray break on line 1' -> LiveScript.compile \break
throws 'stray continue on line 1' -> LiveScript.compile \continue


### Line folding after `for` prepositions
for x of
   {2}
  for y in
     [3] by
     -1
    for z from
        5 til
        6
      eq x*y*z, 30


### Function Plucking
# Function literals in loops are defined outside.
them = []
them.push(->) until them.1
eq ...them


### IIFE Scoping
# IIFE constructions under `for` auto-capture the loop variables.
fs = for a, i in [1 2]
  for b from 3 to 4
    let i = i+5
      -> i + a + b
sums = (f() for f in fs)
eq sums.1, 10
eq sums.2, 11

fs = for x, y of {2 3 5} then let z = 7 then -> x * y * z
eq 63 fs.1()

os = for n in [11 13] then new -> import n: -> n
eq 11 os.0.n()


### Post-`for` chains
eq "#{
  a * b * c * d         \
  for a of {1}          \
  for b in [2]          \
  for c in [3, 4] by -1 \
  for d from 5 to 6     \
  for _ of {7}
}", '40,30,48,36'


### Anaphoric
while 1
  break for ever
  eq that, 1
  break


### Destructuring `for`-`of`
r = 0
r += a * b * i for [a, b] i in [[2 3] [5 7]]
r += a + b + i for {a, b} i in [{\a \b}]
eq r, '35ab0'


### Post condition
i = 0
do
  do
    ++i
  until true
while ++i < 2
eq i, 2

(-> eq '4,2,0' ''+it) do
  i * 2
while i--


### Update clause
i = 0; evens = (i while i < 9, i += 2)
eq '0,2,4,6,8' ''+evens

i = 1; odds = until i > 9, ++i
  continue unless i &&& 1
  i
eq '1,3,5,7,9' ''+odds

a = [1 2 3]
b = []
continue while a.pop(), b.push that
eq '3,2,1' ''+b


### `else` clause
for cond in [true false]
  while cond
    break
  else
    ok not cond

r = for i til 1 then i else [9]
eq 0 r.0

r = for i til 0 then i else [9]
eq 9 r.0


### Omission of `for`'s first assignment
eq i, 0 for    , i in [0]
eq v, 1 for    , v of {1}
eq v, 2 for own, v of {2}

### When
evens = (x for x from 1 to 10 | x % 2 is 0)
eq 5 evens.length
eq 4 evens.1

for x in <[ amy bibs ashley charlie danny alex ]> when x.charAt(0) is \a
  ok x in <[ amy ashley alex ]>

while i < evens.length, ++i when evens[i] * 2 is 8
  eq 4 evens[i] 

eq '1 3 7 9' (y for y from 1 to 10 when y isnt 5 by 2).join ' '


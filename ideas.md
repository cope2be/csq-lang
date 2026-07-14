idea dump

will expand on edge cases later (too lazy)

# target
switch from c99 to c11

# fns
## named args
use an opt in design with '.'

```c
void foo(bool bar, bool .baz);
void foo2(bool .bar2, bool .baz2);

foo(true, .baz = false); // transpiles to "foo(true, false);"
foo2(.baz2 = true, .bar2 = false); // transpiles to "foo2(false, true);"
```

## default args
can only accept stuff that's known at comptime

```c
void foo(int x = 100);

foo(); // transpiles to "foo(100);"
```

## overload
copied zig (heh)

```c
int do_int(int x, int y);
float do_float(float x, float y);

auto do_math
{
	do_int;
	do_float;
};
```

# import
wow, fancy import

also, the transpiler will generate the header

still going to have '#include' as an escape hatch tho

## standard
```c
#import std::mem
```

## wildcard
```c
#import std::mem::*
```

## aliasing
note: the format's ".member = alias"

```c
#import std::{ .mem = memory }
```

```c
#import std::mem::{ .new = malloc, .free }
```

# namespace
inspired by c with classes

does ugly name mangling by default (haven't decided on the formatting yet)

TODO: expand later

# idk what to call this
applicable to operators (math too) and indexing

## question mark
### get
return null if the operation fails

```c
int x[5] = { 7, 4, 9, 1, 0 };

int? y = x?[2]; // return "9"
ing? z = x?[100]; // return null
```

### set
do nop if the operation fails
unless wrapped in an parenthesis, then return itself or null

```c
int x = 100;
int *y = &x;

int? z = (*y ?= 1717175); // return the int if it succeed, null if it fails
```

## bang
### get
basically like the question mark, but panic instead of it fails

### set
same as the get, panic if it fails

idea dump

will expand on edge cases later (too lazy)

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

## overloading
copied zig (heh)

```c
int do_int(int x, int y);
float do_float(float x, float y);

auto do_math
{
	do_int,
	do_float
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

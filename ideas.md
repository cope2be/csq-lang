idea dump

will expand on edge cases and impl details later (too lazy)

# target
switch from c99 to c11

# fns
## named args
use an opt in design with '.'

```c
void foo(bool bar, bool .baz);
void foo2(bool .bar2, bool .baz2);

foo(true, .baz = false); // becomes "foo(true, false);"
foo2(.baz2 = true, .bar2 = false); // becomes "foo2(false, true);", the transpiler rearranges based on the signature
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

do ugly name mangling by default (haven't decided on the formatting yet)

TODO: expand later

# array slice
TODO: finish

# idk what to call this
applicable to operators (math too) and indexing

note: for math operators, it fails when there is an overflow (should include math errs too?)

## null coalescing(?)
returns itself if suceeded, fallback if failed

### get
```c
int x[5] = { 0, 3, 238, 1, 123 };

int y = x?[2] : -1; // returns '238'
int z = x?[100] : -1; // returns '-1'
```

### set
note: to set something in a chain and return it, it must be wrap inside parens

```c
// imagine 'user' is a nested struct
// and THEME is an int

// return 'DARK_THEME' if the pointers are valid
// return 'LIGHT_THEME' if the pointers are invalid
THEME user_theme = (user?->profile?->setting?->theme = DARK_THEME : LIGHT_THEME);

// user?->profile?->setting?->theme = DARK_THEME; // this also work, but does a nop instead if it fails
```

### math
```c
int x = 10010101;
int y = 23213;

// return the result when the operation succeed
// return the fallback when it fails
int z = x ?+ y : -1;
```

## panic
basically null coalescing
but instead of returning the fallback, it panics instead

```c
int x[5] = { 0, 3, 238, 1, 123 };

int y = x![2]; // nothing bad happens
int z = x![100]; // panic of doom and despair
```

# interface
TODO: finish

# generic
note: this is just a rough concept

the transpiler will do a type erasure for both types

## typed
note: i know this is redundant, but _Generic is ugly as hell

another note: should i switch this to monomorphism instead? (it's evil tho :v)

for known and finite types

the transpiler ensures that generic param can only be of the types that the user chose

it'll also inject a type_id

```c
// i'm considering inline unions
typedef union foo_types
{
	int x;
	float y;
};

void foo<foo_types T>(T bar)
{
	// desugarify base on the type_id
	if (typeof(bar) == int)
		printf("i'm an int!")
	else
		printf("i'm a float!")
	
	// unified sizeof and alignof!
	printf("%zu", sizeof(bar));
	printf("%zu", alignof(bar));
}
```

## omni
TODO: finish trait and impl first

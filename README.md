# overview
this is a highly experimental and wip proof of concept project

it tries to make c "safer" by adding dedicated pointer types

# notes
edge cases are plenty

bugs are full

struct is downgraded

# pipeline
parse only the necessary

transpile (c99) and spit the rest out

let tinycc do the syntax validation

# pointer types
behave exactly like standard c pointers, but ownership (exclusive to only owned pointers) is moved with '^'

|     type     | symbol |                          property                         |
|:------------:|:------:|:---------------------------------------------------------:|
|   nullable   |    ~   | can point to nullptr, but requires an explicit null check |
| non nullable |    *   |       cannot point to nullptr, only valid addresses       |
|     owned    |    ^   | a variant of non nullable, lifetime's tracked at comptime |

## nullable
```c
int x = 15;
int ~nullable_ptr = &x;

// printf("%d\n", *nullable_ptr); // comperr, requires a null check

if (nullable_ptr != nullptr)
{
	printf("%d\n", *nullable_ptr);
}
```

## non nullable
```c
int x = 15;

// int *non_nullable_ptr = nullptr // comperr, non nullable cannot point to nullptr
int *non_nullable_ptr = &x;

print("%d\n", *non_nullable_ptr); // no comperr
```

## owned
note: 'free' is mandatory in scopes that own pointers (defer later)
```c
int ^owned_ptr = malloc(sizeof(int) * 5);

// void proc(int *ptr);
// void cons(int ^ptr);

proc(&owned_ptr); // proc borrows the pointer
cons(^owned_ptr); // cons take ownership of the pointer

// free(^owned_ptr); // comperr, the current scope no longer owns 'owned_ptr'
```

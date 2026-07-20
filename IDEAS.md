idea dump (wew)

most edges will not be addressed

but some will be expanded on later

# philosophies
* no implicit behaviors (where it is stupid)
* remain syntactically close to standard c as much as possible
* every features must be deterministic and predictable
* every features also must be able to map to standard c cleanly

# changes
* no `goto`
* no pointer arithmetic
* no (unsafe) type punning
* no implicit lossy type conversions

# pipeline
* switch target to c11

# pointer types
the bread and butter

> [!NOTE]
> pointers are still passed like standard c
>
> just with the addition of passing ownerships

## non nullable
* obviously cannot point to `nullptr`
* doesn't require `nullptr` check (duh)
* its sigil is `*`

```c
i64 foo = 2569;
i64 *bar = &foo;

// do whatever
```

## nullable
* the only pointer that is allowed to point to `nullptr`
* requires `nullptr` check
* its sigil is `~`

```c
i64 foo = 2569;
i64 ~bar = nullptr;

if (bar != nullptr)
{
	// `bar` is promoted to non nullable
	// so do whatever!
}
```

## owned

* a variant of non nullable
* its sigil is `^`
* ownership is also passed via `^`
* requires freeing before its owner scope ends

```c
// i know `malloc` can returns `NULL`
// but this is just for the sake of demonstration
i64 ^foo = malloc(100 * sizeof(i64));

// void borrow(i64 *a);
// void consume(i64 ^a);

borrow(&foo); // pass only the reference
consume(^foo); // pass the ownership and `foo` becomes uninit

// also just for demonstration
// free(^foo); // error! the scope no longers own the pointer
```

### ownership tracking
* every owned pointers must be explicity free before its owner scope dies

```c
i64 ^foo = malloc(100 * sizeof(i64));

if (condition)
{
	consume(^foo); // `foo` is now consumed in this block
}
else
{
	// `foo` isn't consumed here
	// `foo` still have to be consumed here tho

	// so do whatever!	
}

// as `foo` may or may not be consumed here
// `foo` will be uninit here
```

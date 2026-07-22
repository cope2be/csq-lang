idea dump (wew)

most edges will not be addressed

but some will be expanded on later

# philosophies
* explicibility, predictability, and intent first
	+ magics are fine, they just need to be predictable and deterministic
* every features must map to standard c cleanly
* retain high parity with standard c as much as possible
	+ divergent is fine, but straying too far is not (being shackled won't do anything good)
* trust the programmer to be competent

# minor changes
|          feature          |        change        |
|:-------------------------:|:--------------------:|
|           `goto`          |        removed       |
|        type punning       | replaced by bit cast |
|     pointer arithmetic    |   replaced by slice  |
| implicit lossy conversion |        removed       |

## jump statements
* they can become labelled now

```c
outer_loop: for (condition)
{
	inner_loop: for (condition)
	{
		// break outer_loop;
		continue outer_loop;
	}
}
```

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

borrow(&foo); // pass only the address (borrow)
consume(^foo); // pass the ownership and `foo` becomes uninit

// also just for demonstration
// free(^foo); // error! this scope no longers own the pointer
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

### cyclic references
> [!NOTE]
> to be completely honest, i have no idea on this type of stuff

* only one direction holds ownership
* whereas back references use borrows

```c
struct node
{
	i64 val;
	
	struct node ^child; // the parent owns the child (therefore, responsible for freeing it)
	struct node ~parent; // the child can own borrows the parent
}
```

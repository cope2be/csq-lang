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
> by default, all pointers are non nullable
>
> to add nullability, `?` must be prefixed before the pointer's sigil
>
> nullable pointers also must be null checked before dereferencing

## reference
* its sigil is `*`

```c
i64 foo = 2569;
i64 *bar = &foo;

// do whatever
```

## owned
* its sigil is `^`
* ownership is also passed via `^`
* requires manual freeing before its owner scope ends

```c
i64 ?^foo = malloc(100 * sizeof(i64));

if (foo == nullptr)
	return
	
// `foo` is promoted to non nullable here

// void borrow(i64 *a);
// void consume(i64 ^a);

borrow(&foo); // borrow `foo`
consume(^foo); // consume `foo`, making it uninit in this scope

// free(^foo); // error! this scope no longers own `foo`
```

### ownership tracking
TODO: clarify branch merging rule

```c
if (condition)
{
	consume(^foo); // `foo` becomes consumed here
}
else
{
	// since `foo` haven't been consumed here
	// this scope will be responsible for freeing it

	// so do whatever!	
}

// to prevent sillies
// `foo` will becomes consumed here
```

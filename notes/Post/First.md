# Restrictive Programming
Many of the criticisms of using and learning Haskell are hear are largely based around the idea that Haskell's innovations are mainly just adding restrictions to programming.
Instead of being able to, say, print list of lines you have to do some incantation with `IO ()`.

```haskell
putLines = [String] -> IO ()
-- you could use (sequence :: Monad m => [m a] -> m [a]) but that's no more elucidating
putLines [] = return ()
putLines (x:xs) = putStr x >> putStr "\n" >> putLines xs
```

Which is something you don't have to do if you're just combining them[^1],
```haskell
combineLines :: [String] -> String
combineLines [] = ""
combineLines (s:ss) = s ++ "\n" ++ combineLines ss
```

This, I think, is clearer to those who don't know what `>>` means. But what's confusing here is that they're *different*. This is not the case in language that isn't Haskell,

```js
function putLines(lines) {
	for (let line of lines) {
		console.log(line)
	}
}

function combineLines(lines) {
	let result = ""
	for (let line of lines) {
		result += line
	}
	return result
}
```

My thesis for this post is that the restructions imposed by Haskell make code, globally, more readable. And this makes learning Haskell and spenting time with it valuable, even if you're not using it directly in projects.

[1]: Because `String`s are linked lists this is incredibly inefficient, but all the cool kids use `Text` anyway nowadays. Performance isn't going to be much of a consideration in this post.

## Working from Haskell to Javascript
Haskell is not just Javascript with a bunch of restrictions attached, but thinking about it in these terms is elucidating. My goal here is to provide an equivlency towards Haskell code to Javascript, such that if you porting code you might follow these conventions.

Functions in Haskell are just functions in Javascript that return the expression of that function.

```haskell
discriminant (a,b,c) = b*b - 4*a*c
```

```js
const discriminant = (a,b,c) => (b*b - 4*a*c)
```

Because everything's immutable, instead of for loops we use recursion. This is the first major restriction people come accross. Note that if we were to do this exercise in the other direction this would pose a conundrum, which is why to a first degree we can consider Haskell just Javascript with restrictions.

```haskell
factorial 0 = 1
factorial n = n * (factorial (n-1))
```

```js
const factorial = n => {
	if (n === 0) return 1
	else         return n * factorial(n-1)
}
```

Haskell's pattern matching can, for the most part, nicely map onto `if` statements. Because of automatic memoization the top will run more efficient for large `n`, but we won't worry about performance (this could be easily rectified on the js side if we wanted).

Now, let's try it with an `IO` function, which we can use `putLines` as an example. First we need to define `>>`. If you don't know Haskell, this does the provided operations in order and returns the result of the latter.

```js
const composeActions = (first, second) => {first(); return second();}
```

We have to be careful about conventions, since evaluating `a >> b` doesn't run `a` or `b`, but returns an `IO` that does. Calling this function, by contrast, immediately runs `first` and `second`. I won't mention this difference again since it's not relevant to the point I'm making.

I wrote `composeActions` for illustrative purposes but I'm not going to use it. The idiomatic way to compose actions in javascript is `;`  (or newline).

```js
const putLines = lines => {
	if (lines.length === 0) return
	else {
		console.log(lines[lines.length - 1])
		return putLines(lines.slice(1))
	}
}
```

This ends up being more complicated than Haskell, but only because we wouldn't usually treat linked lists the same as contiguous arrays.

The important thing to note is Haskell functions become Javascript functions. Haskell `IO` *also* become Javascript functions. This is the biggest reason why Haskell feels so restrictive: we can't mix logical functions and I/O functions together in arbitrary ways.

Through this exercise we've discovered that programming in Haskell is basically like programming in Javascript except with the following restrictions,

1. All variables are `const` and immutable, and can only be changed by going down stack frames, forcing us to use recursion.
2. Functions are either "pure" or "IO". A pure function can't do anything except calculate a value from its input and return it. An IO function can do anything. An extension of this is that, if we want a function to remain pure, it can only call pure functions.

## Advantages of restrictions
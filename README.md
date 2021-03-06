# My solutions for [Advent of Code 2020](https://adventofcode.com/2020/)

Using handcrafted [Elixir](https://elixir-lang.org/).

Inspired by [Jacob Rothstein](https://github.com/jbr/advent-2020), I'll try to add some comments on the code and
the challenge.

## Day 1: A nice warmup

When searching for 3 things there is a certain satisfaction in getting the termination conditions right.

## Day 2: Password policies

Elixir moves smoothly from puzzle 1 to puzzle 2, but `String.to_integer/1` is a bit much to type when you
need to do it many times.  Are there other solutions?

## Day 3: Toboggan in a grid

I applied some tips from one of the AoC pros (from a post that I will link to once I find it again): Avoid x & y
when the input is rows and columns.  In the input processing, rows come before columns, and 0,0 (or 1,1) is in the
top-left corner.  If you don't have to map that to x & y (reverse order of rows & columns, uncertain 0,0), you save
yourself a lot of trouble.  Also, enjoy long, descriptive variable names as often as you can, but use `row` & `col`
consistently, or `r` and `c` in loops. Very solid advice.

## Day 4: Passport attributes

I would have liked to convert the input to code _in the code_ and not in my head, but it didn't feel regular
enough, nor did I think that the rules would change later.

## Day 5: Binary Boarding

If I hadn't been forced to spend a lot of time between reading the puzzle and sitting down to write code, I would
have written code that was a lot closer to the problem description, and that would have been lots of more code than
I ended up writing after having some time to think.

## Day 6: All or any?

Knowing from the outset that your language has your back and will provide set operations like _intersection_ makes
it a lot easier to write the code.  Maybe too easy.

## Day 7: The transitive closure is a bag

I think the resulting code looks nice, but it wasn't necessarily quick to write.  It would have been nice if the
options to `Regex` were readily visible in my (LSP-enabled) editor, or at least in online documentation of the 
relevant functions, rather than just somwhere at the beginning of the `Regex` doc file.

Also good to think about when to create an internal representation of the input, and when not.  In an
object-oriented language it's easy to store the external representation and only expose it through methods, thus
postponing the question.  In Elixir, I feel like I'm being almost indecent by exposing the data (in whatever
format!) and don't know what the best pattern is.

I always think that a Ruby object is more or less equivalent to an Elixir process, but somehow it feels like
overkill to use processes for something this simple.  Maybe I should try, and compare the results?

## Day 8: Handheld Halting

Finally a taste of last year's IntCode machine!  I've been looking forward to use Erlang's `array` ever since, and
I like how it turned out. A bit surprising to see `:array.get/2` take `position, array` and not the other way
around, but Erlang's ways are not ours. In the second half, the code felt too indirect when writing, and in
hindsight I should have focussed on the algorithm and waited with the implementation of the mutation function, just
stubbing it out with some no-op while I did the three-pronged `cond`.  (That `cond` should actually have one more
case before the `true`: a check if the new `ip` falls outside the code, except for immediately after the last
instruction, which seemed like a very possible if unspecified option.)

I'm tempted to hide the mutation in a lazy (`Stream`) producer and see if that makes the code look nicer.

## Day 9: Sliding window over array

This kind of task is not what comes most natural in Elixir, and that in itself provides a nice challenge.  I
considered using Erlang's `queue` module to have something that naturally represents the sliding window, but
decided against it after realising that the queue would have to be dumped into an array on every step.

I'm still struggling to find a good balance between using function heads and `case` statements for flow control.
I guess I always will.

## Day 10: Path-finding & combinatorics

My first reaction was to break out Erlang's `digraph`, but it only has functions for shortest path, not for a path
that visits all nodes.  And thinking about the problem a bit made it clear that anything fancy like that would have
been a waste of time and efforts.  In a way, this becomes like school maths problems where the challenge is to
translate the text problem to a simple calculation, rather than my everyday work where the challenge is to model
the environment, thereby creating entities which can be combined in interesting ways.

Also: the lack of something akin to Ruby's `Enumerable.each_cons` was pretty annoying.  Using `Enum.each_chunk` +
`Enum.filter` works but does not reveal intent.

## Day 11: Game of life, sort of

How did the Constructor create seating plans that would lead to termination in not too many generations, for all
participants?  I've participated in many code retreats, but I've never bothered to study Game of Life further. Now
my interest is piqued.

Also: an interesting meta-challenge to keep the solution to puzzle 1 around when parts of the specification changes
(rather than getting added to).  I feel that I took the safe way out.

## Day 12: Manhattan

I did most of the 2019 edition and have peaked at the other years, and it seems like Manhattan distance is a
recurring theme.  Perhaps because it makes for good puzzles that don't take all day to solve.  Anyway, the word
"probably" in the instructions set off my spider-senses, but I decided not to design for what probably was to come
since defensive programming makes for bad puzzle solutions.  It was interesting to see that the change from the
first to the second puzzle required very small changes, and would have required even less if I had not written the
first rotate function based on some vague memory of something similar last year.

## Note to self

Start new solutions with `./new ModuleName`.

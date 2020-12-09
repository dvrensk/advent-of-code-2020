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

## Note to self

Start new solutions with `./new ModuleName`.

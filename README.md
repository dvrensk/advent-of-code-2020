# My solutions for [Advent of Code 2020](https://adventofcode.com/2020/)

Using handcrafted [Elixir](https://elixir-lang.org/).

Inspired by [Jacob Rothstein](https://github.com/jbr/advent-2020), I'll try to add some comments on the code and
the challenge.

## Day 8: Handheld Halting

Finally a taste of last year's IntCode machine!  I've been looking forward to use Erlang's `array` ever since, and
I like how it turned out. A bit surprising to see `:array.get/2` take `position, array` and not the other way
around, but Erlang's ways are not ours. In the second half, the code felt too indirect when writing, and in
hindsight I should have focussed on the algorithm and waited with the implementation of the mutation function, just
stubbing it out with some no-op while I did the three-pronged `cond`.  (That `cond` should actually have one more
case before the `true`: a check if the new `ip` falls outside the code, except for immediately after the last
instruction, which seemed like a very possible if unspecified option.)

## Note to self

Start new solutions with `./new ModuleName`.

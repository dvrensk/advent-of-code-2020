defmodule HandyHaversacksTest do
  use ExUnit.Case
  doctest HandyHaversacks

  test "puzzle 1: what's my bag in?" do
    HandyHaversacks.enclosures("shiny gold", File.read!("input.txt"))
    |> Enum.count()
    |> assert_eq(185)
  end

  def input_lines(path \\ "input.txt"),
    do: File.read!(path) |> String.split("\n", trim: true)

  def input_paragraphs(path \\ "input.txt"),
    do: File.read!(path) |> String.split("\n\n", trim: true)

  def input_ints(path \\ "input.txt"),
    do: File.read!(path) |> String.split() |> Enum.map(&String.to_integer/1)

  def assert_eq(a, b), do: assert(a == b)
end

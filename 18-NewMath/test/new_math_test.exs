defmodule NewMathTest do
  use ExUnit.Case
  doctest NewMath

  test "puzzle 1: sum of rows" do
    input_lines()
    |> Enum.map(&NewMath.eval/1)
    |> Enum.sum()
    |> assert_eq(4_297_397_455_886)
  end

  def input(path \\ "input.txt"), do: File.read!(path)
  def input_lines(path \\ "input.txt"), do: input(path) |> String.split("\n", trim: true)
  def input_paragraphs(path \\ "input.txt"), do: input(path) |> String.split("\n\n", trim: true)

  def input_ints(path \\ "input.txt"),
    do: input(path) |> String.split() |> Enum.map(&String.to_integer/1)

  def assert_eq(a, b), do: assert(a == b)
end

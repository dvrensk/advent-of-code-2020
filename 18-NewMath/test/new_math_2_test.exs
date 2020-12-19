defmodule NewMath2Test do
  use ExUnit.Case
  doctest NewMath2

  test "puzzle 2: sum of rows" do
    input_lines()
    |> Enum.map(&NewMath2.eval/1)
    |> Enum.sum()
    |> assert_eq(93_000_656_194_428)
  end

  def input(path \\ "input.txt"), do: File.read!(path)
  def input_lines(path \\ "input.txt"), do: input(path) |> String.split("\n", trim: true)
  def input_paragraphs(path \\ "input.txt"), do: input(path) |> String.split("\n\n", trim: true)

  def input_ints(path \\ "input.txt"),
    do: input(path) |> String.split() |> Enum.map(&String.to_integer/1)

  def assert_eq(a, b), do: assert(a == b)
end

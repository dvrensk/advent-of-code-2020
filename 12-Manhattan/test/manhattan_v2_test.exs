defmodule ManhattanV2Test do
  use ExUnit.Case
  doctest ManhattanV2

  test "puzzle 2" do
    input_lines()
    |> ManhattanV2.run()
    |> assert_eq(71586)
  end

  def input(path \\ "input.txt"), do: File.read!(path)
  def input_lines(path \\ "input.txt"), do: input(path) |> String.split("\n", trim: true)
  def input_paragraphs(path \\ "input.txt"), do: input(path) |> String.split("\n\n", trim: true)

  def input_ints(path \\ "input.txt"),
    do: input(path) |> String.split() |> Enum.map(&String.to_integer/1)

  def assert_eq(a, b), do: assert(a == b)
end

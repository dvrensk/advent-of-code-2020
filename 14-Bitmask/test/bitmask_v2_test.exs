defmodule BitmaskV2Test do
  use ExUnit.Case
  doctest BitmaskV2

  test "puzzle 2" do
    input()
    |> BitmaskV2.run()
    |> Map.values()
    |> Enum.sum()
    |> assert_eq(3_440_662_844_064)
  end

  def input(path \\ "input.txt"), do: File.read!(path)
  def input_lines(path \\ "input.txt"), do: input(path) |> String.split("\n", trim: true)
  def input_paragraphs(path \\ "input.txt"), do: input(path) |> String.split("\n\n", trim: true)

  def input_ints(path \\ "input.txt"),
    do: input(path) |> String.split() |> Enum.map(&String.to_integer/1)

  def assert_eq(a, b), do: assert(a == b)
end

defmodule JoltsTest do
  use ExUnit.Case
  doctest Jolts

  test "puzzle 1: product of 1-steps and 3-steps" do
    input_ints()
    |> Jolts.jolt_diffs()
    |> assert_eq(1984)
  end

  def input(path \\ "input.txt"), do: File.read!(path)
  def input_lines(path \\ "input.txt"), do: input(path) |> String.split("\n", trim: true)
  def input_paragraphs(path \\ "input.txt"), do: input(path) |> String.split("\n\n", trim: true)

  def input_ints(path \\ "input.txt"),
    do: input(path) |> String.split() |> Enum.map(&String.to_integer/1)

  def assert_eq(a, b), do: assert(a == b)
end

defmodule EncodingErrorTest do
  use ExUnit.Case
  doctest EncodingError

  test "puzzle 1: first encoding error" do
    input_ints()
    |> EncodingError.first_fail()
    |> assert_eq(23_278_925)
  end

  test "puzzle 2: first weakness" do
    input_ints()
    |> EncodingError.encryption_weakness()
    |> assert_eq(4_011_064)
  end

  def input(path \\ "input.txt"), do: File.read!(path)
  def input_lines(path \\ "input.txt"), do: input(path) |> String.split("\n", trim: true)
  def input_paragraphs(path \\ "input.txt"), do: input(path) |> String.split("\n\n", trim: true)

  def input_ints(path \\ "input.txt"),
    do: input(path) |> String.split() |> Enum.map(&String.to_integer/1)

  def assert_eq(a, b), do: assert(a == b)
end

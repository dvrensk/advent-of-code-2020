defmodule CustomFormsTest do
  use ExUnit.Case
  doctest CustomForms

  test "puzzle 1: add the sizes" do
    input_paragraphs()
    |> Enum.map(&CustomForms.any_yes_in_group/1)
    |> Enum.reduce(0, fn e, acc -> acc + map_size(e) end)
    |> assert_eq(6542)
  end

  test "puzzle 2: add the sizes" do
    input_paragraphs()
    |> Enum.map(&CustomForms.all_yes_in_group/1)
    |> Enum.reduce(0, fn e, acc -> acc + length(e) end)
    |> assert_eq(3299)
  end

  def input_lines(path \\ "input.txt"),
    do: File.read!(path) |> String.split("\n", trim: true)

  def input_paragraphs(path \\ "input.txt"),
    do: File.read!(path) |> String.split("\n\n", trim: true)

  def ints_from_file(path \\ "input.txt"),
    do: File.read!(path) |> String.split() |> Enum.map(&String.to_integer/1)

  def assert_eq(a, b), do: assert(a == b)
end

defmodule HandheldHaltingTest do
  use ExUnit.Case
  doctest HandheldHalting

  test "puzzle 1: what's acc?" do
    input()
    |> HandheldHalting.run_until_loop()
    |> Map.get(:acc)
    |> assert_eq(1200)
  end

  test "puzzle 2: swap one to exit" do
    input()
    |> HandheldHalting.run_until_done()
    |> assert_eq({327, %{acc: 1023, ip: 643}})
  end

  def input(path \\ "input.txt"), do: File.read!(path)
  def input_lines(path \\ "input.txt"), do: input(path) |> String.split("\n", trim: true)
  def input_paragraphs(path \\ "input.txt"), do: input(path) |> String.split("\n\n", trim: true)

  def input_ints(path \\ "input.txt"),
    do: input(path) |> String.split() |> Enum.map(&String.to_integer/1)

  def assert_eq(a, b), do: assert(a == b)
end

defmodule BinaryBoardingTest do
  use ExUnit.Case
  doctest BinaryBoarding

  test "puzzle 1: max seat id in file" do
    input_lines()
    |> Enum.map(&BinaryBoarding.seat_id/1)
    |> Enum.max(fn -> 0 end)
    |> assert_eq(965)
  end

  test "puzzle 2: my seat in file" do
    input_lines()
    |> Enum.map(&BinaryBoarding.seat_id/1)
    |> Enum.sort()
    |> BinaryBoarding.first_gap()
    |> assert_eq(524)
  end

  def input_lines(path \\ "input.txt"),
    do: File.read!(path) |> String.split("\n", trim: true)
  def ints_from_file(path \\ "input.txt"),
    do: File.read!(path) |> String.split() |> Enum.map(&String.to_integer/1)
  def assert_eq(a, b), do: assert(a == b)
end

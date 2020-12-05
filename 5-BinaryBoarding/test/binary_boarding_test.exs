defmodule BinaryBoardingTest do
  use ExUnit.Case
  doctest BinaryBoarding

  test "puzzle 1: max seat id in file" do
    File.read!("input.txt")
    |> String.split()
    |> Enum.map(&BinaryBoarding.seat_id/1)
    |> Enum.max(fn -> 0 end)
    |> assert_eq(965)
  end
  def assert_eq(a, b), do: assert(a == b)
end

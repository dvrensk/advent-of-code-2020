defmodule TobogganTrajectoryTest do
  use ExUnit.Case
  doctest TobogganTrajectory

  test "puzzle 1: right 3, down 1" do
    File.read!("input.txt")
    |> TobogganTrajectory.parse_forest()
    |> TobogganTrajectory.right_3_down_1()
    |> assert_eq(247)
  end

  def assert_eq(a, b), do: assert(a == b)
end

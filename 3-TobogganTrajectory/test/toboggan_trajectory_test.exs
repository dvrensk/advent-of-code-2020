defmodule TobogganTrajectoryTest do
  use ExUnit.Case
  doctest TobogganTrajectory

  test "puzzle 1: right 3, down 1" do
    File.read!("input.txt")
    |> TobogganTrajectory.parse_forest()
    |> TobogganTrajectory.right_n_down_m(3, 1)
    |> assert_eq(247)
  end

  test "puzzle 2: 5 slopes" do
    File.read!("input.txt")
    |> TobogganTrajectory.parse_forest()
    |> TobogganTrajectory.five_slopes_product()
    |> assert_eq(2_983_070_376)
  end

  def assert_eq(a, b), do: assert(a == b)
end

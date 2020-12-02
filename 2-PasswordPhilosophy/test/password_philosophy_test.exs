defmodule PasswordPhilosophyTest do
  use ExUnit.Case
  doctest PasswordPhilosophy

  test "puzzle 1: count valid in input, old-job style" do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> PasswordPhilosophy.count_valid_old()
    |> assert_eq(614)
  end

  test "puzzle 2: count valid in input, new-job style" do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> PasswordPhilosophy.count_valid_new()
    |> assert_eq(354)
  end

  def assert_eq(a, b), do: assert(a == b)
end

defmodule PasswordPhilosophyTest do
  use ExUnit.Case
  doctest PasswordPhilosophy

  test "puzzle 1: count valid in input" do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> PasswordPhilosophy.count_valid()
    |> assert_eq(614)
  end

  def assert_eq(a, b), do: assert(a == b)
end

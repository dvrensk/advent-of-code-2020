defmodule PassportProcessingTest do
  use ExUnit.Case
  doctest PassportProcessing

  test "puzzle 1: count valid-ish passports" do
    File.read!("input.txt")
    |> PassportProcessing.count_valid_1_in_input()
    |> assert_eq(233)
  end

  test "puzzle 2: count valid passports" do
    File.read!("input.txt")
    |> PassportProcessing.count_valid_2_in_input()
    |> assert_eq(111)
  end

  def assert_eq(a, b), do: assert(a == b)
end

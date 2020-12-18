defmodule NumbersTest do
  use ExUnit.Case
  doctest Numbers

  test "puzzle 1" do
    assert Numbers.spoken("17,1,3,16,19,0", 2020) == 694
  end

  test "puzzle 2" do
    assert Numbers.spoken("17,1,3,16,19,0", 30_000_000) == 21_768_614
  end

  def assert_eq(a, b), do: assert(a == b)
end

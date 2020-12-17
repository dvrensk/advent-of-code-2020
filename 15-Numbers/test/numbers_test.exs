defmodule NumbersTest do
  use ExUnit.Case
  doctest Numbers

  test "puzzle 1" do
    assert Numbers.spoken_2020("17,1,3,16,19,0") == 694
  end

  def assert_eq(a, b), do: assert(a == b)
end

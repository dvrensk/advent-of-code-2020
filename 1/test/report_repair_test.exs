defmodule ReportRepairTest do
  use ExUnit.Case
  doctest ReportRepair

  test "puzzle 1" do
    assert 211899 = ReportRepair.product_of_2020(ints_from_file("input.txt"))
  end

  test "reads ints from file" do
    assert [1728, 1621 | _] = ints_from_file("input.txt")
  end

  def ints_from_file(name) do
    File.read!(name)
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end
end

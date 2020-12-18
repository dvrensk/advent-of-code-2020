defmodule TicketRulesTest do
  use ExUnit.Case
  doctest TicketRules

  test "puzzle 1: error rate in nearby" do
    assert TicketRules.error_rate(input()) == 22977
  end

  # test "names in 2" do
  #   input()
  #   |> TicketRules.myopic_possibilities()
  #   |> TicketRules.restricted_possibilities()
  #   |> assert_eq([])
  # end

  test "puzzle 2: departure checksum" do
    assert TicketRules.puzzle2(input()) == 998_358_379_943
  end

  def input(path \\ "input.txt"), do: File.read!(path)
  def input_lines(path \\ "input.txt"), do: input(path) |> String.split("\n", trim: true)
  def input_paragraphs(path \\ "input.txt"), do: input(path) |> String.split("\n\n", trim: true)

  def input_ints(path \\ "input.txt"),
    do: input(path) |> String.split() |> Enum.map(&String.to_integer/1)

  def assert_eq(a, b), do: assert(a == b)
end

defmodule TicketRules do
  @doc """
  iex> import TicketRules
  iex> error_rate(sample())
  71
  """
  def error_rate(input) do
    %{rules: rules, nearby: nearby} = parse(input)

    nearby
    |> Enum.flat_map(&invalid_values(&1, rules))
    |> Enum.sum()
  end

  @doc """
  iex> import TicketRules
  iex> rules = %{"class" => [1..3, 5..7], "row" => [6..11, 33..44], "seat" => [13..40, 45..50]}
  iex> invalid_values([7,3,47], rules)
  []
  iex> invalid_values([40,4,50], rules)
  [4]
  iex> invalid_values([55,4,20], rules)
  [55,4]
  """
  def invalid_values(ticket, rules) do
    ranges = Map.values(rules) |> List.flatten()

    ticket
    |> Enum.filter(fn n -> ranges |> Enum.all?(fn r -> !Enum.member?(r, n) end) end)
  end

  @doc """
  iex> import TicketRules
  iex> parse(sample())
  %{rules: %{"class" => [1..3, 5..7], "row" => [6..11, 33..44], "seat" => [13..40, 45..50]},
    mine: [7,1,14],
    nearby: [[7,3,47], [40,4,50], [55,2,20], [38,6,12]]}
  """
  def parse(input) do
    [a, "your ticket:\n" <> b, "nearby tickets:\n" <> c] = String.split(input, "\n\n", trim: true)

    %{
      rules: parse_rules(a),
      mine: parse_ticket(b),
      nearby: String.split(c) |> Enum.map(&parse_ticket/1)
    }
  end

  def parse_rules(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_rule/1)
    |> Map.new()
  end

  def parse_rule(str) do
    [name | nums] = Regex.run(~r/(\w+): (\d+)-(\d+) or (\d+)-(\d+)/, str, capture: :all_but_first)
    [a1, a2, b1, b2] = Enum.map(nums, &String.to_integer/1)
    {name, [a1..a2, b1..b2]}
  end

  def parse_ticket(str), do: str |> String.split(",") |> Enum.map(&String.to_integer/1)

  def sample() do
    """
    class: 1-3 or 5-7
    row: 6-11 or 33-44
    seat: 13-40 or 45-50

    your ticket:
    7,1,14

    nearby tickets:
    7,3,47
    40,4,50
    55,2,20
    38,6,12
    """
  end
end

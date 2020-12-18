defmodule TicketRules do
  def puzzle2(input) do
    names =
      input
      |> myopic_possibilities()
      |> restricted_possibilities()

    %{mine: mine} = parse(input)
    List.zip([names, mine])
    |> Enum.filter(&match?({"departure"<>_, _}, &1))
    |> Enum.map(&elem(&1,1))
    |> Enum.reduce(fn n, acc -> acc * n end)
  end
  @doc """
  iex> ([["row"], ["class", "row"], ["class", "row", "seat"]]
  ...> |> TicketRules.restricted_possibilities())
  ~w[row class seat]
  """
  def restricted_possibilities(myopic) do
    if restricted?(myopic) do
      myopic |> List.flatten()
    else
      singles = singles_in(myopic)

      myopic
      |> Enum.map(fn
        [a] -> [a]
        longer -> Enum.reject(longer, &Enum.member?(singles, &1))
      end)
      |> restricted_possibilities()
    end
  end

  def restricted?(myopic),
    do:
      Enum.all?(myopic, fn
        [_] -> true
        _ -> false
      end)

  def singles_in(list_of_lists),
    do: list_of_lists |> Enum.filter(&match?([_], &1)) |> List.flatten()

  @doc """
  iex> import TicketRules
  iex> myopic_possibilities(sample(2))
  [["row"], ["class", "row"], ["class", "row", "seat"]]
  """
  def myopic_possibilities(input) do
    %{rules: rules, mine: mine, nearby: nearby} = parse(input)
    good = nearby |> Enum.filter(fn t -> invalid_values(t, rules) == [] end)

    [mine | good]
    |> Enum.map(fn ticket -> ticket |> Enum.map(&compatibility(&1, rules)) end)
    |> transpose()
    |> Enum.map(&reduce_to_common/1)
  end

  def compatibility(n, rules) do
    rules
    |> Enum.filter(fn {_name, [r1, r2]} -> Enum.member?(r1, n) or Enum.member?(r2, n) end)
    |> Enum.map(&elem(&1, 0))
  end

  def transpose(rows), do: rows |> List.zip() |> Enum.map(&Tuple.to_list/1)

  @doc """
  iex> ([["class", "row", "seat"], ["row", "seat"], ["class", "row"], ["class", "row", "seat"]]
  ...> |> TicketRules.reduce_to_common())
  ["row"]
  """
  def reduce_to_common(list_of_lists) do
    list_of_lists
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(&MapSet.intersection/2)
    |> MapSet.to_list()
  end

  @doc """
  iex> import TicketRules
  iex> error_rate(sample(1))
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
  iex> parse(sample(1))
  %{rules: %{"class" => [1..3, 5..7], "row" => [6..11, 33..44], "seat" => [13..40, 45..50]},
    mine: [7,1,14],
    nearby: [[7,3,47], [40,4,50], [55,2,20], [38,6,12]]}
  iex> parse(sample(2))
  %{rules: %{"class" => [0..1, 4..19], "row" => [0..5, 8..19], "seat" => [0..13, 16..19]},
    mine: [11,12,13],
    nearby: [[3,9,18], [15,1,5], [5,14,9]]}
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
    [name | nums] = Regex.run(~r/([^:]+): (\d+)-(\d+) or (\d+)-(\d+)/, str, capture: :all_but_first)
    [a1, a2, b1, b2] = Enum.map(nums, &String.to_integer/1)
    {name, [a1..a2, b1..b2]}
  end

  def parse_ticket(str), do: str |> String.split(",") |> Enum.map(&String.to_integer/1)

  def sample(1) do
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

  def sample(2) do
    """
    class: 0-1 or 4-19
    row: 0-5 or 8-19
    seat: 0-13 or 16-19

    your ticket:
    11,12,13

    nearby tickets:
    3,9,18
    15,1,5
    5,14,9
    """
  end
end

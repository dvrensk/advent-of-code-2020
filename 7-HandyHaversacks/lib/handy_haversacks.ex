defmodule HandyHaversacks do
  @doc """
  iex> import HandyHaversacks
  iex> enclosures("shiny gold", sample_input()) |> Enum.sort
  ["bright white", "dark orange", "light red", "muted yellow"]
  """
  def enclosures(bag_type, rules) do
    direct = direct_enclosures(bag_type, rules)

    direct
    |> Enum.flat_map(&enclosures(&1, rules))
    |> Enum.concat(direct)
    |> Enum.uniq()
  end

  @doc """
  iex> import HandyHaversacks
  iex> direct_enclosures("shiny gold", sample_input()) |> Enum.sort
  ["bright white", "muted yellow"]
  """
  def direct_enclosures(bag_type, rules) do
    Regex.compile!("^(\\w+ \\w+) bags contain.* \\d+ #{bag_type}", [:multiline])
    |> Regex.scan(rules, capture: :all_but_first)
    |> Enum.map(&hd/1)
  end

  def sample_input() do
    """
    light red bags contain 1 bright white bag, 2 muted yellow bags.
    dark orange bags contain 3 bright white bags, 4 muted yellow bags.
    bright white bags contain 1 shiny gold bag.
    muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
    shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
    dark olive bags contain 3 faded blue bags, 4 dotted black bags.
    vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
    faded blue bags contain no other bags.
    dotted black bags contain no other bags.
    """
  end
end

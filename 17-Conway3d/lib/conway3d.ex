defmodule Conway3d do
  @doc """
  iex> Conway3d.count_after_6(Conway3d.sample())
  112
  """
  def count_after_6(input) do
    world = parse(input)
    Enum.reduce(1..6, world, fn _, w -> next_gen(w) end)
    |> map_size()
  end

  @doc """
  iex> import Conway3d
  iex> next_gen(parse(sample())) |> Map.keys() |> length()
  11
  """
  def next_gen(world) do
    Map.merge(survive(world), born(world))
  end

  @doc """
  iex> import Conway3d
  iex> survive(parse(sample())) |> Map.keys() |> Enum.sort()
  [{1,2,0}, {2,1,0}, {2,2,0}]
  """
  def survive(world) do
    world
    |> Enum.filter(fn {pos, _} ->
      count = active_neighbours(pos, world) |> length()
      count == 2 || count == 3
    end)
    |> Map.new()
  end

  def born(world) do
    world
    |> Map.keys()
    |> Enum.flat_map(&neighbours/1)
    |> Enum.uniq()
    |> Enum.filter(fn pos -> active_neighbours(pos, world) |> length() == 3 end)
    |> Map.new(fn pos -> {pos, 1} end)
  end

  def active_neighbours(pos, world) do
    pos
    |> neighbours()
    |> Enum.filter(&Map.has_key?(world, &1))
  end

  def neighbours({r, c, z}) do
    for(i <- [-1, 0, 1], j <- [-1, 0, 1], k <- [-1, 0, 1], do: {i, j, k})
    |> Enum.reject(&match?({0, 0, 0}, &1))
    |> Enum.map(fn {rr, cc, zz} -> {r + rr, c + cc, z + zz} end)
  end

  @doc """
  iex> Conway3d.parse(Conway3d.sample()) |> Map.keys() |> Enum.sort()
  [{0,1,0}, {1,2,0}, {2,0,0}, {2,1,0}, {2,2,0}]
  """
  def parse(input) do
    input
    |> String.split()
    |> Enum.with_index()
    |> Enum.flat_map(&parse_row/1)
    |> Map.new(fn pos -> {pos, 1} end)
  end

  def parse_row({row, r}) do
    row
    |> String.codepoints()
    |> Enum.with_index()
    |> Enum.map(fn
      {".", _} -> nil
      {"#", c} -> {r, c, 0}
    end)
    |> Enum.reject(&is_nil/1)
  end

  def sample() do
    """
    .#.
    ..#
    ###
    """
  end
end

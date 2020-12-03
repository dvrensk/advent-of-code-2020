defmodule TobogganTrajectory do
  @moduledoc """
  Documentation for `TobogganTrajectory`.
  """

  @doc """
  Count trees going down.

      iex> forest = TobogganTrajectory.parse_forest(TobogganTrajectory.sample_forest())
      iex> forest |> TobogganTrajectory.right_3_down_1()
      7
  """
  def right_3_down_1({_trees, max_row, _max_col} = forest) do
    0..max_row
    |> Enum.count(fn r -> tree?(forest, {r, r * 3}) end)
  end

  @doc """
  Find a tree in a forest.
  ## Examples

      iex> forest = TobogganTrajectory.parse_forest(TobogganTrajectory.sample_forest())
      iex> forest |> TobogganTrajectory.tree?({0, 2})
      true
      iex> forest |> TobogganTrajectory.tree?({4, 12})
      true
  """
  def tree?({trees, _max_row, max_col}, {r, c}) do
    trees[{r, rem(c, max_col + 1)}]
  end

  @doc """
  Parse a forest.
  ## Examples

      iex> {trees, max_row, max_col} = TobogganTrajectory.parse_forest(TobogganTrajectory.sample_forest())
      iex> max_row
      10
      iex> max_col
      10
      iex> trees[{0,0}]
      false
      iex> trees[{2,6}]
      true
  """
  def parse_forest(string) do
    pairs =
      string
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, r} ->
        row
        |> String.codepoints()
        |> Enum.with_index()
        |> Enum.map(fn {square, c} ->
          {{r, c}, square == "#"}
        end)
      end)

    trees = Map.new(pairs)
    {{r, c}, _} = pairs |> Enum.reverse() |> hd()
    {trees, r, c}
  end

  def sample_forest() do
    """
    ..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#
    """
  end
end

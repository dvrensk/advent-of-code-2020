defmodule TobogganTrajectory do
  @moduledoc """
  Documentation for `TobogganTrajectory`.
  """

  @doc """
  iex> forest = TobogganTrajectory.parse_forest(TobogganTrajectory.sample_forest())
  iex> TobogganTrajectory.five_slopes_product(forest)
  336
  """
  def five_slopes_product(forest) do
    five_slopes(forest)
    |> Enum.reduce(1, fn count, acc -> count * acc end)
  end

  @doc """
  * Right 1, down 1.
  * Right 3, down 1. (This is the slope you already checked.)
  * Right 5, down 1.
  * Right 7, down 1.
  * Right 1, down 2.

  iex> forest = TobogganTrajectory.parse_forest(TobogganTrajectory.sample_forest())
  iex> TobogganTrajectory.five_slopes(forest)
  [2, 7, 3, 4, 2]
  """
  def five_slopes(forest) do
    [
      {1, 1},
      {3, 1},
      {5, 1},
      {7, 1},
      {1, 2}
    ]
    |> Enum.map(fn {n, m} -> TobogganTrajectory.right_n_down_m(forest, n, m) end)
  end

  @doc """
  iex> forest = TobogganTrajectory.parse_forest(TobogganTrajectory.sample_forest())
  iex> forest |> TobogganTrajectory.right_n_down_m(3, 1)
  7
  iex> forest |> TobogganTrajectory.right_n_down_m(1, 1)
  2
  iex> forest |> TobogganTrajectory.right_n_down_m(1, 2)
  2
  iex> forest |> TobogganTrajectory.right_n_down_m(1, 3)
  0
  """
  def right_n_down_m({_trees, max_row, _max_col} = forest, n, m) do
    0..max_row
    |> Enum.filter(fn r -> rem(r, m) == 0 end)
    |> Enum.count(fn r -> tree?(forest, {r, div(r * n, m)}) end)
  end

  @doc """
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

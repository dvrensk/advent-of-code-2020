defmodule SeatingV2 do
  @doc """
  iex> SeatingV2.count_occupied_in_final(SeatingV2.sample(1))
  26
  """
  def count_occupied_in_final(input) do
    input
    |> parse()
    |> stabilise()
    |> Enum.count(fn
      {_, "#"} -> true
      _ -> false
    end)
  end

  @doc """
  iex> seats = SeatingV2.parse(SeatingV2.sample(1))
  iex> final = SeatingV2.stabilise(seats)
  iex> final == SeatingV2.parse(SeatingV2.sample(7))
  true
  """
  def stabilise(seats) do
    case next_gen(seats) do
      ^seats -> seats
      other -> stabilise(other)
    end
  end

  @doc """
  iex> seats = SeatingV2.parse(SeatingV2.sample(1))
  iex> next = SeatingV2.next_gen(seats)
  iex> next[{0,0}]
  "#"
  iex> next == SeatingV2.parse(SeatingV2.sample(2))
  true
  iex> third = SeatingV2.next_gen(next)
  iex> third == SeatingV2.parse(SeatingV2.sample(3))
  true
  iex> fourth = SeatingV2.next_gen(third)
  iex> fourth == SeatingV2.parse(SeatingV2.sample(4))
  true
  """
  def next_gen(seats) do
    seats
    |> Enum.map(fn
      {{r, c}, "L"} -> {{r, c}, if(occ_vis(r, c, seats) == 0, do: "#", else: "L")}
      {{r, c}, "#"} -> {{r, c}, if(occ_vis(r, c, seats) >= 5, do: "L", else: "#")}
      floor -> floor
    end)
    |> Map.new()
  end

  def occ_vis(r, c, seats) do
    for(rr <- [-1, 0, 1], cc <- [-1, 0, 1], do: {rr, cc})
    |> Enum.reject(&(&1 == {0, 0}))
    |> Enum.count(&visible(&1, {r, c}, seats))
  end

  def visible({dr, dc} = delta, {r, c} = viewpoint, seats, factor \\ 1) do
    seats[{r + factor * dr, c + factor * dc}]
    |> case do
      "#" -> true
      "." -> visible(delta, viewpoint, seats, factor + 1)
      _ -> false
    end
  end

  @doc """
  iex> seats = SeatingV2.parse(SeatingV2.sample(1))
  iex> seats[{0,0}]
  "L"
  iex> seats[{2,1}]
  "."
  """
  def parse(string) do
    string
    |> String.split()
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, r} ->
      row
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.map(fn {square, c} ->
        {{r, c}, square}
      end)
    end)
    |> Map.new()
  end

  def sample(1) do
    """
    L.LL.LL.LL
    LLLLLLL.LL
    L.L.L..L..
    LLLL.LL.LL
    L.LL.LL.LL
    L.LLLLL.LL
    ..L.L.....
    LLLLLLLLLL
    L.LLLLLL.L
    L.LLLLL.LL
    """
  end

  def sample(2) do
    """
    #.##.##.##
    #######.##
    #.#.#..#..
    ####.##.##
    #.##.##.##
    #.#####.##
    ..#.#.....
    ##########
    #.######.#
    #.#####.##
    """
  end

  def sample(3) do
    """
    #.LL.LL.L#
    #LLLLLL.LL
    L.L.L..L..
    LLLL.LL.LL
    L.LL.LL.LL
    L.LLLLL.LL
    ..L.L.....
    LLLLLLLLL#
    #.LLLLLL.L
    #.LLLLL.L#
    """
  end

  def sample(4) do
    """
    #.L#.##.L#
    #L#####.LL
    L.#.#..#..
    ##L#.##.##
    #.##.#L.##
    #.#####.#L
    ..#.#.....
    LLL####LL#
    #.L#####.L
    #.L####.L#
    """
  end

  def sample(5) do
    """
    #.L#.L#.L#
    #LLLLLL.LL
    L.L.L..#..
    ##LL.LL.L#
    L.LL.LL.L#
    #.LLLLL.LL
    ..L.L.....
    LLLLLLLLL#
    #.LLLLL#.L
    #.L#LL#.L#
    """
  end

  def sample(6) do
    """
    #.L#.L#.L#
    #LLLLLL.LL
    L.L.L..#..
    ##L#.#L.L#
    L.L#.#L.L#
    #.L####.LL
    ..#.#.....
    LLL###LLL#
    #.LLLLL#.L
    #.L#LL#.L#
    """
  end

  def sample(7) do
    """
    #.L#.L#.L#
    #LLLLLL.LL
    L.L.L..#..
    ##L#.#L.L#
    L.L#.LL.L#
    #.LLLL#.LL
    ..#.L.....
    LLL###LLL#
    #.LLLLL#.L
    #.L#LL#.L#
    """
  end
end

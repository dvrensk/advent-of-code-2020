defmodule SeatingV1 do
  @doc """
  iex> SeatingV1.count_occupied_in_final(SeatingV1.sample(1))
  37
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
  iex> seats = SeatingV1.parse(SeatingV1.sample(1))
  iex> final = SeatingV1.stabilise(seats)
  iex> final == SeatingV1.parse(SeatingV1.sample(6))
  true
  """
  def stabilise(seats) do
    case next_gen(seats) do
      ^seats -> seats
      other -> stabilise(other)
    end
  end

  @doc """
  iex> seats = SeatingV1.parse(SeatingV1.sample(1))
  iex> next = SeatingV1.next_gen(seats)
  iex> next[{0,0}]
  "#"
  iex> next == SeatingV1.parse(SeatingV1.sample(2))
  true
  iex> third = SeatingV1.next_gen(next)
  iex> third == SeatingV1.parse(SeatingV1.sample(3))
  true
  """
  def next_gen(seats) do
    seats
    |> Enum.map(fn
      {{r, c}, "L"} -> {{r, c}, if(occ_adj(r, c, seats) == 0, do: "#", else: "L")}
      {{r, c}, "#"} -> {{r, c}, if(occ_adj(r, c, seats) >= 4, do: "L", else: "#")}
      floor -> floor
    end)
    |> Map.new()
  end

  def occ_adj(r, c, seats) do
    for(rr <- [-1, 0, 1], cc <- [-1, 0, 1], do: {r + rr, c + cc})
    |> Enum.count(fn
      {^r, ^c} -> false
      pos -> seats[pos] == "#"
    end)
  end

  @doc """
  iex> seats = SeatingV1.parse(SeatingV1.sample(1))
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
    #.LL.L#.##
    #LLLLLL.L#
    L.L.L..L..
    #LLL.LL.L#
    #.LL.LL.LL
    #.LLLL#.##
    ..L.L.....
    #LLLLLLLL#
    #.LLLLLL.L
    #.#LLLL.##
    """
  end

  def sample(4) do
    """
    #.##.L#.##
    #L###LL.L#
    L.#.#..#..
    #L##.##.L#
    #.##.LL.LL
    #.###L#.##
    ..#.#.....
    #L######L#
    #.LL###L.L
    #.#L###.##
    """
  end

  def sample(5) do
    """
    #.#L.L#.##
    #LLL#LL.L#
    L.L.L..#..
    #LLL.##.L#
    #.LL.LL.LL
    #.LL#L#.##
    ..L.L.....
    #L#LLLL#L#
    #.LLLLLL.L
    #.#L#L#.##
    """
  end

  def sample(6) do
    """
    #.#L.L#.##
    #LLL#LL.L#
    L.#.L..#..
    #L##.##.L#
    #.#L.LL.LL
    #.#L#L#.##
    ..L.L.....
    #L#L##L#L#
    #.LLLLLL.L
    #.#L#L#.##
    """
  end
end

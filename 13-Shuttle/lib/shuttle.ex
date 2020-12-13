defmodule Shuttle do
  @doc """
  7,13,x,x,59,x,31,19 -> 1068781
  The earliest timestamp that matches the list 17,x,13,19 is 3417.
  67,7,59,61 first occurs at timestamp 754018.
  67,x,7,59,61 first occurs at timestamp 779210.
  67,7,x,59,61 first occurs at timestamp 1261476.
  1789,37,47,1889 first occurs at timestamp 1,202,161,486.

  [{17, 0}, {13, 2}, {19, 3}]
  t = 17a - 0 = 13b - 2 = 19c - 3

  iex> Shuttle.cascade("17,x,13,19")
  3417
  iex> Shuttle.cascade("1789,37,47,1889")
  1202161486
  iex> Shuttle.cascade("7,13,x,x,59,x,31,19")
  1068781
  """
  def cascade(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn
      {"x", _} -> nil
      {str, i} -> {String.to_integer(str), i}
    end)
    |> Enum.reject(&is_nil/1)
    |> Enum.sort()
    |> Enum.reverse()
    |> find_t()
  end

  def find_t([{k, m} | rest] = list, n \\ 1) do
    if rem(n, 1_000_000) == 0, do: IO.inspect(div(n, 1_000_000))
    t = k * n - m

    check(rest, t)
    |> case do
      ^t -> t
      _ -> find_t(list, n + 1)
    end
  end

  def check([], t), do: t

  def check([{k, m} | rest], t) do
    case rem(t + m, k) do
      0 -> check(rest, t)
      n -> {k, n}
    end
  end

  @doc """
  iex> Shuttle.next(Shuttle.sample())
  295
  """
  def next(input) do
    [now | shuttles] =
      Regex.scan(~r/\d+/, input)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)

    {wait, id} =
      shuttles
      |> Enum.map(fn period -> {period - rem(now, period), period} end)
      |> Enum.min(fn -> nil end)

    wait * id
  end

  def sample() do
    """
    939
    7,13,x,x,59,x,31,19
    """
  end
end

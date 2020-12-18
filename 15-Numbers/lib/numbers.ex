defmodule Numbers do
  @doc """
  iex> Numbers.spoken("0,3,6", 2020)
  436
  """
  def spoken(input, limit), do: start(input) |> run_until(limit)

  def run_until({ix, prev, _}, ix), do: prev
  def run_until(list, ix), do: next(list) |> run_until(ix)

  @doc """
  iex> res = Numbers.next({3, 6, %{0 => [1], 3 => [2], 6 => [3]}})
  {4, 0, %{0 => [4,1], 3 => [2], 6 => [3]}}
  iex> res = Numbers.next(res)
  {5, 3, %{0 => [4,1], 3 => [5,2], 6 => [3]}}
  iex> Numbers.next(res)
  {6, 3, %{0 => [4,1], 3 => [6,5,2], 6 => [3]}}
  """
  def next({ix, prev, mem}) do
    case mem[prev] do
      [_] -> {ix + 1, 0, add(mem, 0, ix + 1)}
      [b, a | _] -> {ix + 1, b - a, add(mem, b - a, ix + 1)}
    end
  end

  @doc """
  iex> Numbers.start("0,3,6")
  {3, 6, %{0 => [1], 3 => [2], 6 => [3]}}
  """
  def start(input) do
    numbers =
      input
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

    mem =
      numbers
      |> Enum.with_index(1)
      |> Enum.reduce(%{}, fn {n, ix}, mem -> add(mem, n, ix) end)

    {length(numbers), hd(Enum.reverse(numbers)), mem}
  end

  def add(mem, n, ix), do: Map.update(mem, n, [ix], fn list -> [ix | list] end)
end

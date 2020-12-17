defmodule Numbers do
  @doc """
  iex> Numbers.spoken_2020("0,3,6")
  436
  """
  def spoken_2020(input) do
    start(input)
    |> run_until(2020)
    |> hd()
    |> elem(0)
  end

  def run_until([{_, x} | _] = list, x), do: list
  def run_until(list, x), do: next(list) |> run_until(x)

  @doc """
  iex> Numbers.next([{6,3}, {3,2}, {0, 1}])
  [{0,4}, {6,3}, {3,2}, {0, 1}]
  iex> Numbers.next([{0,4}, {6,3}, {3,2}, {0, 1}])
  [{3,5}, {0,4}, {6,3}, {3,2}, {0, 1}]
  iex> Numbers.next([{3,5}, {0,4}, {6,3}, {3,2}, {0, 1}])
  [{3,6}, {3,5}, {0,4}, {6,3}, {3,2}, {0, 1}]
  """
  def next([{spoken, ix} | mem] = all_mem) do
    Enum.find(mem, fn {x, _} -> x == spoken end)
    |> case do
      nil -> [{0, ix + 1} | all_mem]
      {_, pos} -> [{ix - pos, ix + 1} | all_mem]
    end
  end

  @doc """
  iex> Numbers.start("0,3,6")
  [{6,3}, {3,2}, {0, 1}]
  """
  def start(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.reduce({1, []}, fn x, {ix, mem} -> {ix + 1, [{String.to_integer(x), ix} | mem]} end)
    |> elem(1)
  end
end

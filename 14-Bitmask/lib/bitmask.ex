defmodule Bitmask do
  import Bitwise

  @doc """
  iex> Bitmask.run(Bitmask.sample)
  %{"8" => 64, "7" => 101}
  """
  def run(str) do
    ["mask = " <> mask | cmds] = str |> String.split("\n", trim: true)
    {andmask, ormask} = masks(mask)
    cmds
    |> Enum.map(&Regex.run(~r/(\d+)] = (\d+)/, &1, capture: :all_but_first))
    |> Enum.map(fn [pos, val] -> [pos, val |> String.to_integer |> bor(ormask) |> band(andmask)] end)
    |> Enum.reduce(%{}, fn [pos, val], mem -> Map.put(mem, pos, val) end)
  end

  @doc """
  Returns {andmask, ormask}
  iex> Bitmask.masks("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X") |> elem(1)
  64
  iex> floor(:math.pow(2,36))
  68719476736
  iex> (Bitmask.masks("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X") |> elem(0))
  68719476733
  iex> floor(:math.pow(2,36)) - 1 - (Bitmask.masks("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X") |> elem(0))
  2
  """
  def masks(string) do
    andmask = String.replace(string, "X", "1") |> String.to_integer(2)
    ormask = String.replace(string, "X", "0") |> String.to_integer(2)
    {andmask, ormask}
  end

  def sample() do
    """
    mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
    mem[8] = 11
    mem[7] = 101
    mem[8] = 0
    """
  end
end

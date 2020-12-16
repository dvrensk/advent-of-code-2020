defmodule Bitmask do
  import Bitwise

  defstruct mem: %{}, ormask: 0, andmask: 0

  @doc """
  iex> Bitmask.run(Bitmask.sample)
  %{"8" => 64, "7" => 101}
  """
  def run(str) do
    str
    |> String.split("\n", trim: true)
    |> run(%__MODULE__{})
  end

  def run([], %{mem: mem}), do: mem

  def run(["mask = " <> mask | cmds], state) do
    {andmask, ormask} = masks(mask)
    run(cmds, %{state | andmask: andmask, ormask: ormask})
  end

  def run([cmd | cmds], %{mem: mem, ormask: ormask, andmask: andmask} = state) do
    [pos, val] = Regex.run(~r/(\d+)] = (\d+)/, cmd, capture: :all_but_first)
    val = val |> String.to_integer() |> bor(ormask) |> band(andmask)
    run(cmds, %{state | mem: Map.put(mem, pos, val)})
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

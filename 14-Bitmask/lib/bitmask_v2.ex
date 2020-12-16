defmodule BitmaskV2 do
  import Bitwise

  defstruct mem: %{}, mask: nil

  @doc """
  iex> BitmaskV2.run(BitmaskV2.sample)
  %{16 => 1, 17 => 1, 18 => 1, 19 => 1, 24 => 1, 25 => 1, 26 => 1, 27 => 1, 58 => 100, 59 => 100}
  """
  def run(str) do
    str
    |> String.split("\n", trim: true)
    |> run(%__MODULE__{})
  end

  def run([], %{mem: mem}), do: mem
  def run(["mask = " <> mask | cmds], state), do: run(cmds, %{state | mask: mask})

  def run([cmd | cmds], %{mem: mem, mask: mask} = state) do
    [pos, val] =
      Regex.run(~r/(\d+)] = (\d+)/, cmd, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)

    new_mem =
      positions_for_mask(pos, mask)
      |> Enum.reduce(mem, &Map.put(&2, &1, val))

    run(cmds, %{state | mem: new_mem})
  end

  @doc """
  iex> BitmaskV2.positions_for_mask(2, "000")
  [2]
  iex> BitmaskV2.positions_for_mask(2, "100")
  [6]
  iex> BitmaskV2.positions_for_mask(2, "10X") |> Enum.sort()
  [6,7]
  iex> BitmaskV2.positions_for_mask(26, "00000000000000000000000000000000X0XX") |> Enum.sort()
  [16,17,18,19,24,25,26,27]
  """
  def positions_for_mask(pos, mask) do
    mask
    |> String.reverse()
    |> String.codepoints()
    |> Enum.with_index()
    |> Enum.reduce([pos], fn
      {"0", _ix}, poss ->
        poss

      {"1", ix}, poss ->
        Enum.map(poss, fn p -> bor(p, bsl(1, ix)) end)

      {"X", ix}, poss ->
        Enum.flat_map(poss, fn p ->
          [
            bor(p, bsl(1, ix)),
            p - band(p, bsl(1, ix))
          ]
        end)
    end)
  end

  def sample() do
    """
    mask = 000000000000000000000000000000X1001X
    mem[42] = 100
    mask = 00000000000000000000000000000000X0XX
    mem[26] = 1
    """
  end
end

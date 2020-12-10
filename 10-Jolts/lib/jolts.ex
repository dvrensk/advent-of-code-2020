defmodule Jolts do
  @doc """
  iex> Jolts.jolt_diffs(Jolts.sample(1))
  35
  iex> Jolts.jolt_diffs(Jolts.sample(2))
  220
  """
  def jolt_diffs(list) do
    counts =
      [0 | list]
      |> Enum.sort()
      |> Enum.chunk_every(2, 1)
      |> Enum.filter(fn chunk -> length(chunk) == 2 end)
      |> Enum.map(fn [a, b] -> b - a end)
      |> Enum.group_by(fn x -> x end)
      |> Enum.map(fn {k, list} -> {k, length(list)} end)
      |> Map.new()

    counts[1] * (counts[3] + 1)
  end

  def sample(1) do
    [16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4]
  end

  def sample(2) do
    [
      28,
      33,
      18,
      42,
      31,
      14,
      46,
      20,
      48,
      47,
      24,
      23,
      49,
      45,
      19,
      38,
      39,
      11,
      1,
      32,
      25,
      35,
      8,
      17,
      7,
      9,
      4,
      2,
      34,
      10,
      3
    ]
  end
end

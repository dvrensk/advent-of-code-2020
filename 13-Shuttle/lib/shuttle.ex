defmodule Shuttle do
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

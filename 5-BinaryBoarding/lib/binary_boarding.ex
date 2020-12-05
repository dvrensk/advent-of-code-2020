defmodule BinaryBoarding do
  @doc """
  ## Examples
  iex> BinaryBoarding.seat_id("BFFFBBFRRR")
  567
  iex> BinaryBoarding.seat_id("FFFBBBFRRR")
  119
  iex> BinaryBoarding.seat_id("BBFFBBFRLL")
  820
  """
  def seat_id(str) do
    str
    |> String.replace(~w[B R], "1")
    |> String.replace(~w[F L], "0")
    |> String.to_integer(2)
  end

  @doc """
  iex> BinaryBoarding.first_gap([3,4,5,7,8])
  6
  """
  def first_gap([a, b | _]) when a + 2 == b, do: a + 1
  def first_gap([_ | rest]), do: first_gap(rest)
end

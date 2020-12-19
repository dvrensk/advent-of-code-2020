defmodule NewMath2 do
  @doc """
  iex> NewMath2.eval("1 + 2 * 3")
  9
  iex> NewMath2.eval("3 * 2 + 1")
  9
  iex> NewMath2.eval("(3 * 2) + 1")
  7
  iex> NewMath2.eval("1 + (2 * 3) + (4 * (5 + 6))")
  51
  """
  def eval(str) do
    str
    |> replace_subexpressions()
    |> String.split()
    |> calc()
  end

  def replace_subexpressions(str) do
    if String.contains?(str, "(") do
      Regex.replace(
        ~r/\(([^(]+?)\)/,
        str,
        fn _, sub -> eval(sub) |> Integer.to_string() end
      )
      |> replace_subexpressions()
    else
      str
    end
  end

  def calc(list), do: calc_plus(list, []) |> calc_times()

  def calc_plus([a], acc), do: Enum.reverse([a | acc])
  def calc_plus([a, "+", b | rest], acc), do: calc_plus([int(a) + int(b) | rest], acc)
  def calc_plus([a, op, b | rest], acc), do: calc_plus([b | rest], [op, a | acc])

  def calc_times([a]), do: a
  def calc_times([a, "*", b | rest]), do: calc_times([int(a) * int(b) | rest])

  def int(a) when is_integer(a), do: a
  def int(a) when is_binary(a), do: String.to_integer(a)

  def sample() do
    """
    """
  end
end

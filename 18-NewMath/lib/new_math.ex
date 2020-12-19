defmodule NewMath do
  @doc """
  iex> NewMath.eval("1 + 2 * 3")
  9
  iex> NewMath.eval("1 + (2 * 3)")
  7
  iex> NewMath.eval("1 + (2 * 3) + (4 * (5 + 6))")
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

  def calc([a]), do: a
  def calc([a, "+", b | rest]), do: calc([int(a) + int(b) | rest])
  def calc([a, "*", b | rest]), do: calc([int(a) * int(b) | rest])

  def int(a) when is_integer(a), do: a
  def int(a) when is_binary(a), do: String.to_integer(a)

  def sample() do
    """
    """
  end
end

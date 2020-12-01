defmodule ReportRepair do
  @moduledoc """
  Documentation for `ReportRepair`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ReportRepair.product_of_2020([1721, 979, 366, 299, 675, 1456])
      514579

  """
  def product_of_2020(list) do
    {a, b} = find_pair(list, 2020)
    a * b
  end

  def find_pair([a | list], target) do
    find_pair(list, a, target - a)
    |> case do
      :not_found -> find_pair(list, target)
      pair -> pair
    end
  end

  def find_pair([], _a, _b), do: :not_found
  def find_pair([b | _], a, b), do: {a, b}
  def find_pair([_ | rest], a, b), do: find_pair(rest, a, b)
end

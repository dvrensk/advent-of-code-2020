defmodule ReportRepair do
  @moduledoc """
  Documentation for `ReportRepair`.
  """

  @spec product_of_2020(list()) :: number
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

  @spec triple_product_of_2020(list()) :: number
  @doc """
  Hello world.

  ## Examples

      iex> ReportRepair.triple_product_of_2020([1721, 979, 366, 299, 675, 1456])
      241861950
  """
  def triple_product_of_2020(list) do
    {a, b, c} = find_triple(list, 2020)
    a * b * c
  end

  def find_triple([a | list], target) do
    find_pair(list, target - a)
    |> case do
      :not_found -> find_triple(list, target)
      {b, c} -> {a, b, c}
    end
  end

  def find_pair([_], _target), do: :not_found

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

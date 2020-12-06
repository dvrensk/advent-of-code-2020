defmodule CustomForms do
  @doc """
      iex> CustomForms.any_yes_in_group("ab\\nac")
      %{"a" => true, "b" => true, "c" => true}
  """
  def any_yes_in_group(string) do
    Regex.scan(~r/\w/, string)
    |> Enum.map(fn [a] -> {a, true} end)
    |> Map.new()
  end

  @doc """
      iex> CustomForms.all_yes_in_group("ab\\nac")
      ["a"]
  """
  def all_yes_in_group(string) do
    string
    |> String.split()
    |> Enum.map(fn s -> s |> String.codepoints() |> MapSet.new() end)
    |> Enum.reduce(&MapSet.intersection/2)
    |> Enum.to_list()
  end
end

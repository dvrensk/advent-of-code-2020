defmodule CustomForms do
  @doc """
      iex> CustomForms.yes_in_group("ab\\nac")
      %{"a" => true, "b" => true, "c" => true}
  """
  def yes_in_group(string) do
    Regex.scan(~r/\w/, string)
    |> Enum.map(fn [a] -> {a, true} end)
    |> Map.new()
  end
end

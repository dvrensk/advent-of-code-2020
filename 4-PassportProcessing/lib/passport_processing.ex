defmodule PassportProcessing do
  # Leaving out "cid" for now
  @required_keys ~w[ byr ecl eyr hcl hgt iyr pid ]

  @spec count_valid_in_input(String.t()) :: non_neg_integer
  @doc """
  iex> import PassportProcessing
  iex> count_valid_in_input(sample_input())
  2
  """
  def count_valid_in_input(input) do
    input
    |> records()
    |> Enum.count(&has_required_keys?/1)
  end

  @spec has_required_keys?(Map.t()) :: boolean
  @doc """
  iex> import PassportProcessing
  iex> records(sample_input()) |> Enum.map(&has_required_keys?/1)
  [true, false, true, false]
  """
  def has_required_keys?(passport) do
    @required_keys
    |> Enum.all?(fn k -> Map.has_key?(passport, k) end)
  end

  @spec records(String.t()) :: [Map.t()]
  @doc """
  iex> import PassportProcessing
  iex> [a,b,c,d] = records(sample_input())
  iex> a["ecl"]
  "gry"
  """
  def records(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn str ->
      str
      |> String.split()
      |> Map.new(fn str2 -> str2 |> String.split(":") |> List.to_tuple() end)
    end)
  end

  @spec sample_input :: String.t()
  def sample_input do
    """
    ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
    byr:1937 iyr:2017 cid:147 hgt:183cm

    iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
    hcl:#cfa07d byr:1929

    hcl:#ae17e1 iyr:2013
    eyr:2024
    ecl:brn pid:760753108 byr:1931
    hgt:179cm

    hcl:#cfa07d eyr:2025 pid:166559648
    iyr:2011 ecl:brn hgt:59in
    """
  end
end

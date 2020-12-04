defmodule PassportProcessing do
  # Leaving out "cid" for now
  @required_keys ~w[ byr ecl eyr hcl hgt iyr pid ]

  @spec count_valid_1_in_input(String.t()) :: non_neg_integer
  @doc """
  iex> import PassportProcessing
  iex> count_valid_1_in_input(sample_input())
  2
  """
  def count_valid_1_in_input(input) do
    input
    |> records()
    |> Enum.count(&has_required_keys?/1)
  end

  @spec count_valid_2_in_input(String.t()) :: non_neg_integer
  @doc """
  iex> import PassportProcessing
  iex> count_valid_2_in_input(sample_invalid())
  0
  iex> count_valid_2_in_input(sample_input())
  2
  """
  def count_valid_2_in_input(input) do
    input
    |> records()
    |> Enum.count(fn passport ->
      has_required_keys?(passport) &&
      errors(passport) == []
    end)
  end

  @doc """
  iex> import PassportProcessing
  iex> [a,b,c,d] = records(sample_invalid())
  iex> errors(a)
  [{"eyr", "1972"}, {"hgt", "170"}, {"pid", "186cm"}]
  iex> errors(b)
  [{"eyr", "1967"}]
  iex> errors(c)
  [{"hcl", "dab227"}]
  iex> errors(d)
  [{"byr", "2007"}, {"ecl", "zzz"}, {"eyr", "2038"}, {"hcl", "74454a"}, {"hgt", "59cm"}, {"iyr", "2023"}, {"pid", "3556412378"}]
  """
  def errors(passport) do
    @required_keys
    |> Enum.map(fn k ->
      v = passport[k]
      case valid?(k, v) do
        true -> nil
        false -> {k, v}
      end
    end)
    |> Enum.reject(&is_nil/1)
  end

  @eyecolours ~w[ amb blu brn gry grn hzl oth ]

  @doc """
  iex> import PassportProcessing
  iex> valid?("byr", "2003")
  false
  iex> valid?("byr", "2002")
  true
  iex> valid?("ecl", "wat")
  false
  iex> valid?("ecl", "brn")
  true
  iex> valid?("hcl", "#123abz")
  false
  iex> valid?("hcl", "123abc")
  false
  iex> valid?("hcl", "#123abc")
  true
  iex> valid?("hgt", "190")
  false
  iex> valid?("hgt", "190in")
  false
  iex> valid?("hgt", "190cm")
  true
  iex> valid?("hgt", "60in")
  true
  iex> valid?("pid", "0123456789")
  false
  iex> valid?("pid", "000000001")
  true
  """
  def valid?("byr", str), do: year?(str, 1920..2002)
  def valid?("iyr", str), do: year?(str, 2010..2020)
  def valid?("eyr", str), do: year?(str, 2020..2030)
  def valid?("ecl", str), do: Enum.member?(@eyecolours, str)
  def valid?("hcl", str), do: Regex.match?(~r/^#[0-9a-f]{6}$/, str)
  def valid?("pid", str), do: Regex.match?(~r/^[0-9]{9}$/, str)

  def valid?("hgt", str) do
    Regex.run(~r/^(\d+)(in|cm)$/, str)
    |> case do
      [_, str, "in"] -> int_in?(str, 59..76)
      [_, str, "cm"] -> int_in?(str, 150..193)
      _ -> false
    end
  end

  defp year?(str, range),
    do: Regex.match?(~r/^\d{4}$/, str) && Enum.member?(range, String.to_integer(str))

  defp int_in?(str, range),
    do: Enum.member?(range, String.to_integer(str))

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

  def sample_invalid do
    """
    eyr:1972 cid:100
    hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

    iyr:2019
    hcl:#602927 eyr:1967 hgt:170cm
    ecl:grn pid:012533040 byr:1946

    hcl:dab227 iyr:2012
    ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

    hgt:59cm ecl:zzz
    eyr:2038 hcl:74454a iyr:2023
    pid:3556412378 byr:2007
    """
  end

  def sample_valid do
    """
    pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
    hcl:#623a2f

    eyr:2029 ecl:blu cid:129 byr:1989
    iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

    hcl:#888785
    hgt:164cm byr:2001 iyr:2015 cid:88
    pid:545766238 ecl:hzl
    eyr:2022

    iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
    """
  end
end

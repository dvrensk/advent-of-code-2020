defmodule PasswordPhilosophy do
  @moduledoc """
  For example, suppose you have the following list:

  1-3 a: abcde
  1-3 b: cdefg
  2-9 c: ccccccccc

  Each line gives the password policy and then the password. The password policy
  indicates the lowest and highest number of times a given letter must appear
  for the password to be valid. For example, 1-3 a means that the password must
  contain a at least 1 time and at most 3 times.

  In the above example, 2 passwords are valid. The middle password, cdefg, is
  not; it contains no instances of b, but needs at least 1. The first and third
  passwords are valid: they contain one a or nine c, both within the limits of
  their respective policies.
  """

  @doc """
  Count valid passwords in list.

  ## Examples

      iex> PasswordPhilosophy.count_valid(["1-3 a: abcde", "1-3 b: cdefg", "2-9 c: ccccccccc"])
      2
  """
  def count_valid(list) do
    list
    |> Enum.count(&valid_password_entry?/1)
  end

  @doc """
  Check if password entry (line) is valid.

  ## Examples

      iex> PasswordPhilosophy.valid_password_entry?("1-3 a: abcde")
      true
      iex> PasswordPhilosophy.valid_password_entry?("2-3 a: abcda")
      true
  """
  def valid_password_entry?(string) do
    [_, min, max, letter, password] = Regex.run(~r/(\d+)-(\d+) (\w): (\w+)/, string)

    count =
      password
      |> String.codepoints()
      |> Enum.count(&Kernel.==(&1, letter))

    Range.new(String.to_integer(min), String.to_integer(max))
    |> Enum.member?(count)
  end
end

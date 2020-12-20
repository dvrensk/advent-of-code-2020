defmodule Bnf do
  @doc """
  iex> Bnf.count_valid(Bnf.sample())
  2
  """
  def count_valid(input) do
    [a, b] = String.split(input, "\n\n", trim: true)

    regex =
      a
      |> parse_grammar()
      |> build_regex_string()
      |> Regex.compile!()

    String.split(b, "\n", trim: true)
    |> Enum.count(&Regex.match?(regex, &1))
  end

  @doc """
  iex> [a,_b] = String.split(Bnf.sample(), "\\n\\n", trim: true)
  iex> grammar = Bnf.parse_grammar(a)
  iex> grammar[0]
  [4,1,5]
  """
  def parse_grammar(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_rule/1)
    |> Map.new()
  end

  @doc """
  iex> [a,_b] = String.split(Bnf.sample(), "\\n\\n", trim: true)
  iex> Bnf.parse_grammar(a) |> Bnf.build_regex_string("4")
  "^a$"
  iex> Bnf.parse_grammar(a) |> Bnf.build_regex_string("(4)(5)")
  "^(a)(b)$"
  iex> Bnf.parse_grammar(a) |> Bnf.build_regex_string("3")
  "^(a)(b)|(b)(a)$"
  iex> Bnf.parse_grammar(a) |> Bnf.build_regex_string("1")
  "^((a)(a)|(b)(b))((a)(b)|(b)(a))|((a)(b)|(b)(a))((a)(a)|(b)(b))$"
  iex> Bnf.parse_grammar(a) |> Bnf.build_regex_string("0")
  "^(a)(((a)(a)|(b)(b))((a)(b)|(b)(a))|((a)(b)|(b)(a))((a)(a)|(b)(b)))(b)$"
  """
  def build_regex_string(grammar, str \\ "0") do
    Regex.replace(~r/\d+/, str, fn ddd ->
      case grammar[int(ddd)] do
        x when is_binary(x) -> x
        {a, b} -> "#{regex(a)}|#{regex(b)}"
        list -> regex(list)
      end
    end)
    |> build_regex_string_loop(grammar)
  end

  def build_regex_string_loop(str, grammar) do
    if Regex.match?(~r/\d/, str),
      do: build_regex_string(grammar, str),
      else: "^#{str}$"
  end

  def regex(list), do: list |> Enum.map(fn a -> "(#{a})" end) |> Enum.join()

  @doc """
  iex> Bnf.parse_rule("0: 4 1 5")
  {0, [4,1,5]}
  iex> Bnf.parse_rule("0: 2 3 | 3 2")
  {0, {[2,3], [3,2]}}
  iex> Bnf.parse_rule("0: \\"x\\"")
  {0, \"x\"}
  """
  def parse_rule(str) do
    [name, rest] = String.split(str, ": ")

    body =
      cond do
        String.contains?(rest, "|") ->
          String.split(rest, "|", trim: true)
          |> Enum.map(&to_intlist/1)
          |> List.to_tuple()

        String.starts_with?(rest, "\"") ->
          String.at(rest, 1)

        true ->
          to_intlist(rest)
      end

    {int(name), body}
  end

  def to_intlist(str), do: String.split(str) |> Enum.map(&int/1)

  defp int(str), do: String.to_integer(str)

  def valid?(_msg, _grammar), do: false

  def sample() do
    """
    0: 4 1 5
    1: 2 3 | 3 2
    2: 4 4 | 5 5
    3: 4 5 | 5 4
    4: "a"
    5: "b"

    ababbb
    bababa
    abbbab
    aaabbb
    aaaabbb
    """
  end
end

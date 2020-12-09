defmodule EncodingError do
  defstruct ~w[mem winlen pos]a

  @type t() :: %__MODULE__{mem: :array.array(integer()), winlen: integer(), pos: integer()}

  def new(input, preamble_length) do
    %__MODULE__{mem: :array.from_list(input), winlen: preamble_length, pos: preamble_length}
  end

  @spec encryption_weakness([non_neg_integer()], non_neg_integer()) :: non_neg_integer()
  @doc """
  iex> import EncodingError
  iex> encryption_weakness(sample_input(), 5)
  62
  """
  def encryption_weakness(input, preamble_length \\ 25) do
    first_fail(input, preamble_length)
    |> find_addends_for_sum_in_list(input)
    |> Enum.min_max()
    |> Tuple.to_list()
    |> Enum.sum()
  end

  @spec find_addends_for_sum_in_list(non_neg_integer(), [non_neg_integer()]) :: [non_neg_integer()]
  def find_addends_for_sum_in_list(sum, [a | rest]) when a >= sum, do: find_in_window(sum, rest)

  def find_addends_for_sum_in_list(sum, [a | rest]) do
    find_addends_for_sum_in_list(sum - a, rest, [a])
    |> case do
      :not_found -> find_addends_for_sum_in_list(sum, rest)
      list -> list
    end
  end

  @spec find_addends_for_sum_in_list(non_neg_integer(), [non_neg_integer()], [non_neg_integer()]) :: [non_neg_integer()] | :not_found
  def find_addends_for_sum_in_list(0, _, as), do: as

  def find_addends_for_sum_in_list(remaining, [a | rest], as) when a <= remaining,
    do: find_addends_for_sum_in_list(remaining - a, rest, [a | as])

  def find_addends_for_sum_in_list(_, _, _), do: :not_found

  @spec first_fail([non_neg_integer()]) :: non_neg_integer()
  def first_fail(input) when is_list(input), do: first_fail(input, 25)

  @spec first_fail([non_neg_integer()], non_neg_integer()) :: non_neg_integer()
  @doc """
  iex> import EncodingError
  iex> first_fail(sample_input(), 5)
  127
  """
  def first_fail(input, preamble_length) when is_list(input),
    do: new(input, preamble_length) |> do_first_fail()

  @spec do_first_fail(EncodingError.t()) :: non_neg_integer()
  def do_first_fail(%__MODULE__{} = state) when is_struct(state) do
    if find_in_window(state, looking_at(state)),
      do: do_first_fail(%{state | pos: state.pos + 1}),
      else: looking_at(state)
  end

  @spec find_in_window(EncodingError.t(), integer) :: boolean
  def find_in_window(%__MODULE__{winlen: 1}, _target), do: false

  def find_in_window(%__MODULE__{mem: mem, winlen: winlen, pos: pos} = state, target) do
    t2 = target - :array.get(pos - winlen, mem)

    (pos - winlen + 1)..(pos - 1)
    |> Enum.find(fn pos -> :array.get(pos, mem) == t2 end)
    |> case do
      nil -> find_in_window(%{state | winlen: winlen - 1}, target)
      _ -> true
    end
  end

  @spec looking_at(EncodingError.t()) :: non_neg_integer()
  @doc """
  iex> import EncodingError
  iex> new(sample_input(), 5) |> looking_at()
  40
  """
  def looking_at(state), do: state.pos |> :array.get(state.mem)

  @spec sample_input :: [non_neg_integer()]
  def sample_input do
    [35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182, 127, 219, 299, 277, 309, 576]
  end
end

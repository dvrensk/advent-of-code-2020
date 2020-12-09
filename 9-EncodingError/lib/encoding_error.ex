defmodule EncodingError do
  defstruct ~w[mem winlen pos]a

  def new(input, preamble_length) do
    %__MODULE__{mem: :array.from_list(input), winlen: preamble_length, pos: preamble_length}
  end

  @doc """
  iex> import EncodingError
  iex> first_fail(sample_input(), 5)
  127
  """
  def first_fail(input) when is_list(input), do: first_fail(input, 25)

  def first_fail(input, preamble_length) when is_list(input),
    do: new(input, preamble_length) |> do_first_fail()

  def do_first_fail(%__MODULE__{} = state) when is_struct(state) do
    if find_in_window(state, looking_at(state)),
      do: do_first_fail(%{state | pos: state.pos + 1}),
      else: looking_at(state)
  end

  def find_in_window(%{winlen: 1}, _target), do: false

  def find_in_window(%{mem: mem, winlen: winlen, pos: pos} = state, target) do
    t2 = target - :array.get(pos - winlen, mem)

    (pos - winlen + 1)..(pos - 1)
    |> Enum.find(fn pos -> :array.get(pos, mem) == t2 end)
    |> case do
      nil -> find_in_window(%{state | winlen: winlen - 1}, target)
      _ -> true
    end
  end

  @doc """
  iex> import EncodingError
  iex> new(sample_input(), 5) |> looking_at()
  40
  """
  def looking_at(state), do: state.pos |> :array.get(state.mem)

  def sample_input do
    [35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182, 127, 219, 299, 277, 309, 576]
  end
end

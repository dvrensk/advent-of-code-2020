defmodule HandheldHalting do
  @spec run_until_done(String.t()) :: {non_neg_integer, %{acc: integer, ip: integer}}
  @doc """
  iex> import HandheldHalting
  iex> run_until_done(sample_input())
  {7, %{ip: 9, acc: 8}}
  """
  def run_until_done(code), do: load_code(code) |> run_until_done(0)

  @spec run_until_done(:array.array(String.t()), non_neg_integer) :: {non_neg_integer, %{acc: integer, ip: integer}}
  def run_until_done(code, change_here) do
    {changed_code, changed_pos} = change(code, change_here)

    run_until_loop_or_done(changed_code)
    |> case do
      {:done, state} -> {changed_pos, state}
      {:loop, _} -> run_until_done(code, changed_pos + 1)
    end
  end

  @spec run_until_loop_or_done(:array.array(String.t()), %{acc: integer, ip: non_neg_integer}, MapSet.t(integer())) ::
          {:done, %{acc: integer, ip: integer}} | {:loop, %{acc: integer, ip: integer}}
  def run_until_loop_or_done(code, state \\ %{ip: 0, acc: 0}, visited \\ MapSet.new()) do
    new_state = step(code, state)

    cond do
      MapSet.member?(visited, new_state[:ip]) -> {:loop, new_state}
      new_state[:ip] == :array.size(code) -> {:done, new_state}
      true -> run_until_loop_or_done(code, new_state, MapSet.put(visited, state[:ip]))
    end
  end

  @spec change(:array.array(String.t()), non_neg_integer) :: {:array.array(String.t()), non_neg_integer}
  def change(code, pos) do
    case :array.get(pos, code) do
      "nop " <> arg -> {:array.set(pos, "jmp " <> arg, code), pos}
      "jmp " <> arg -> {:array.set(pos, "nop " <> arg, code), pos}
      _ -> change(code, pos + 1)
    end
  end

  @doc """
  iex> import HandheldHalting
  iex> run_until_loop(sample_input())
  %{ip: 1, acc: 5}
  """
  def run_until_loop(code) when is_binary(code),
    do: run_until_loop(load_code(code), %{ip: 0, acc: 0})

  def run_until_loop(code, state, visited \\ MapSet.new()) do
    new_state = step(code, state)

    MapSet.member?(visited, new_state[:ip])
    |> case do
      true -> new_state
      false -> run_until_loop(code, new_state, MapSet.put(visited, state[:ip]))
    end
  end

  @spec step(binary | :array.array(any), %{acc: integer(), ip: non_neg_integer}) :: %{
          acc: integer(),
          ip: integer()
        }
  @doc """
  iex> import HandheldHalting
  iex> step("nop +0", %{ip: 0, acc: 0})
  %{ip: 1, acc: 0}
  iex> step("nop +0\\nacc +5", %{ip: 1, acc: 3})
  %{ip: 2, acc: 8}
  iex> step("nop +0\\njmp -1", %{ip: 1, acc: 3})
  %{ip: 0, acc: 3}
  """
  def step(code, state) when is_binary(code), do: step(load_code(code), state)

  def step(code, %{ip: ip, acc: acc} = state) do
    :array.get(ip, code)
    |> case do
      "nop " <> _ -> %{state | ip: ip + 1}
      "acc " <> arg -> %{state | ip: ip + 1, acc: acc + String.to_integer(arg)}
      "jmp " <> arg -> %{state | ip: ip + String.to_integer(arg)}
    end
  end

  @spec load_code(String.t()) :: :array.array(String.t())
  def load_code(str) do
    str
    |> String.split("\n", trim: true)
    |> :array.from_list()
  end

  @spec sample_input :: String.t()
  def sample_input do
    """
    nop +0
    acc +1
    jmp +4
    acc +3
    jmp -3
    acc -99
    acc +1
    jmp -4
    acc +6
    """
  end
end

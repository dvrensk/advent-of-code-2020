defmodule ManhattanV1 do
  @moduledoc """
  The ship starts by facing east.
  Action N means to move north by the given value.
  Action S means to move south by the given value.
  Action E means to move east by the given value.
  Action W means to move west by the given value.
  Action L means to turn left the given number of degrees.
  Action R means to turn right the given number of degrees.
  Action F means to move forward by the given value in the direction the ship is currently facing.
  In my input file, all rotations are in 90 degree increments.
  """

  defstruct pos: {0, 0}, heading: {0, 1}

  def new(), do: %__MODULE__{}

  @doc """
  iex> ManhattanV1.run(ManhattanV1.sample())
  25
  """
  def run(cmds) do
    run(new(), cmds)
    |> distance()
  end

  @doc """
  iex> import ManhattanV1
  iex> run(new(), sample())
  %ManhattanV1{pos: {-8, 17}, heading: {-1, 0}}
  """
  def run(state, []), do: state

  def run(state, [cmd | cmds]) do
    run1(cmd, state)
    |> run(cmds)
  end

  @doc """
  iex> import ManhattanV1
  iex> run1("F10", new())
  %ManhattanV1{pos: {0, 10}, heading: {0, 1}}
  iex> run1("N10", new())
  %ManhattanV1{pos: {10, 0}, heading: {0, 1}}
  """
  def run1(cmd, state = %{pos: {lat, lng}, heading: {dlat, dlng}}) do
    [ltr, val] = Regex.run(~r/(.)(\d+)/, cmd, capture: :all_but_first)
    val = String.to_integer(val)

    case ltr do
      "F" -> %{state | pos: {lat + dlat * val, lng + dlng * val}}
      "N" -> %{state | pos: {lat + val, lng}}
      "S" -> %{state | pos: {lat - val, lng}}
      "E" -> %{state | pos: {lat, lng + val}}
      "W" -> %{state | pos: {lat, lng - val}}
      "L" -> %{state | heading: rotate(state.heading, val)}
      "R" -> %{state | heading: rotate(state.heading, 360 - val)}
    end
  end

  @headings [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]

  @doc """
  iex> import ManhattanV1
  iex> rotate({0,1}, 90)
  {1,0}
  iex> rotate({1,0}, 270)
  {0,1}
  """
  def rotate(heading, degrees) do
    current = Enum.find_index(@headings, fn h -> h == heading end)
    to = (current + div(degrees, 90)) |> rem(4)
    Enum.at(@headings, to)
  end

  @doc """
  iex> ManhattanV1.distance(%{pos: {-1, 4}})
  5
  """
  def distance(%{pos: {lat, lng}}) do
    abs(lat) + abs(lng)
  end

  def sample() do
    """
    F10
    N3
    F7
    R90
    F11
    """
    |> String.split("\n", trim: true)
  end
end

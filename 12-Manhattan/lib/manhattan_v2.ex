defmodule ManhattanV2 do
  @moduledoc """
  The waypoint starts 10 units east and 1 unit north.
  Action N means to move the waypoint north by the given value.
  Action S means to move the waypoint south by the given value.
  Action E means to move the waypoint east by the given value.
  Action W means to move the waypoint west by the given value.
  Action L means to rotate the waypoint around the ship left (counter-clockwise) the given number of degrees.
  Action R means to rotate the waypoint around the ship right (clockwise) the given number of degrees.
  Action F means to move forward to the waypoint a number of times equal to the given value.
  """

  defstruct pos: {0, 0}, waypoint: {1, 10}

  def new(), do: %__MODULE__{}

  @doc """
  iex> ManhattanV2.run(ManhattanV2.sample())
  286
  """
  def run(cmds) do
    run(new(), cmds)
    |> distance()
  end

  @doc """
  iex> import ManhattanV2
  iex> run(new(), sample())
  %ManhattanV2{pos: {-72, 214}, waypoint: {-10, 4}}
  """
  def run(state, []), do: state

  def run(state, [cmd | cmds]) do
    run1(cmd, state)
    |> run(cmds)
  end

  @doc """
  iex> import ManhattanV2
  iex> run1("F10", new())
  %ManhattanV2{pos: {10, 100}, waypoint: {1, 10}}
  iex> run1("N10", new())
  %ManhattanV2{pos: {0, 0}, waypoint: {11, 10}}
  """
  def run1(cmd, state = %{pos: {lat, lng}, waypoint: {dlat, dlng}}) do
    [ltr, val] = Regex.run(~r/(.)(\d+)/, cmd, capture: :all_but_first)
    val = String.to_integer(val)

    case ltr do
      "F" -> %{state | pos: {lat + dlat * val, lng + dlng * val}}
      "N" -> %{state | waypoint: {dlat + val, dlng}}
      "S" -> %{state | waypoint: {dlat - val, dlng}}
      "E" -> %{state | waypoint: {dlat, dlng + val}}
      "W" -> %{state | waypoint: {dlat, dlng - val}}
      "L" -> %{state | waypoint: rotate(state.waypoint, val)}
      "R" -> %{state | waypoint: rotate(state.waypoint, 360 - val)}
    end
  end

  @doc """
  iex> import ManhattanV2
  iex> rotate({1,10}, 90)
  {10,-1}
  iex> rotate({1,10}, 270)
  {-10,1}
  """
  def rotate({dlat, dlng}, 90), do: {dlng, -dlat}
  def rotate(wp, deg), do: rotate(wp, 90) |> rotate(deg - 90)

  @doc """
  iex> ManhattanV2.distance(%{pos: {-1, 4}})
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

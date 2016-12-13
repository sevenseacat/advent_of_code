defmodule Y2016.Day01 do
  use Advent.Day, no: 1

  @doc """
  iex> Day01.final_distance("R2, L3")
  5

  iex> Day01.final_distance("R2, R2, R2")
  2

  iex> Day01.final_distance("R5, L5, R5, R3")
  12
  """
  def final_distance(input) do
    input
    |> parse_input
    |> calculate_final_position({0, 0}, :north)
    |> calculate_distance
  end

  @doc """
  iex> Day01.hq_distance("R8, R4, R4, R8")
  4
  """
  def hq_distance(input) do
    input
    |> parse_input
    |> calculate_hq_position({0, 0}, :north, MapSet.new())
    |> calculate_distance
  end

  defp calculate_final_position([], position, _facing), do: position

  defp calculate_final_position([move | moves], position, facing) do
    {position, facing} = make_move(move, position, facing)
    calculate_final_position(moves, position, facing)
  end

  defp calculate_distance({x, y}), do: abs(x) + abs(y)

  defp calculate_hq_position([], _, _, _), do: raise("No HQ found")

  defp calculate_hq_position([{_turn, length} = move | moves], position, facing, visited)
       when length > 1 do
    generate_steps(moves, move)
    |> calculate_hq_position(position, facing, visited)
  end

  defp calculate_hq_position([move | moves], position, facing, visited) do
    {position, facing} = make_move(move, position, facing)

    case MapSet.member?(visited, position) do
      true ->
        position

      false ->
        visited = MapSet.put(visited, position)
        calculate_hq_position(moves, position, facing, visited)
    end
  end

  defp generate_steps(moves, {turn, 1}), do: [{turn, 1} | moves]

  defp generate_steps(moves, {turn, length}) do
    # "S" is a new "straight" move, ie: no turn
    generate_steps([{"S", 1} | moves], {turn, length - 1})
  end

  defp make_move({turn, length}, position, facing) do
    facing = turn(facing, turn)
    position = move(position, facing, length)
    {position, facing}
  end

  @doc """
  iex> Day01.turn(:north, "L")
  :west

  iex> Day01.turn(:north, "R")
  :east

  iex> Day01.turn(:west, "L")
  :south

  iex> Day01.turn(:west, "R")
  :north
  """
  def turn(:north, "L"), do: :west
  def turn(:north, "R"), do: :east
  def turn(:south, "L"), do: :east
  def turn(:south, "R"), do: :west
  def turn(:east, "L"), do: :north
  def turn(:east, "R"), do: :south
  def turn(:west, "L"), do: :south
  def turn(:west, "R"), do: :north
  def turn(dir, "S"), do: dir

  defp move({x, y}, :north, length), do: {x, y + length}
  defp move({x, y}, :south, length), do: {x, y - length}
  defp move({x, y}, :east, length), do: {x + length, y}
  defp move({x, y}, :west, length), do: {x - length, y}

  @doc """
  Parse the input string into tuples of actions to take.

  iex> Day01.parse_input("R5, L5, R5, R3")
  [{"R", 5}, {"L", 5}, {"R", 5}, {"R", 3}]
  """
  def parse_input(input) do
    input
    |> String.split(", ")
    |> Enum.map(fn <<turn::binary-size(1), length::binary>> ->
      {turn, String.to_integer(length)}
    end)
  end

  def part1_verify, do: input() |> final_distance()
  def part2_verify, do: input() |> hq_distance()
end

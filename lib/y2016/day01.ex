defmodule Y2016.Day01 do
  use Advent.Day, no: 1

  @directions [:north, :west, :south, :east]

  @doc """
  iex> Day01.distance("R2, L3")
  5

  iex> Day01.distance("R2, R2, R2")
  2

  iex> Day01.distance("R5, L5, R5, R3")
  12
  """
  def distance(input) do
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
    |> calculate_hq_location({0, 0}, :north, MapSet.new())
    |> calculate_distance
  end

  defp calculate_final_position([], position, _), do: position

  defp calculate_final_position([move | moves], position, facing) do
    {turn, length} = move_details(move)
    new_facing = make_turn(facing, turn)
    new_position = move(position, new_facing, length)
    calculate_final_position(moves, new_position, new_facing)
  end

  defp calculate_distance({x, y}), do: abs(x) + abs(y)

  defp move_details(<<turn::binary-size(1), length::binary>>) do
    {turn, String.to_integer(length)}
  end

  defp calculate_hq_location([], _, _, _), do: raise("No HQ found")

  defp calculate_hq_location([move | moves], position, facing, visited) do
    {turn, length} = move_details(move)

    if length > 1 do
      calculate_hq_location(split_moves(moves, {turn, length}), position, facing, visited)
    else
      new_facing = make_turn(facing, turn)
      new_position = move(position, new_facing, length)

      if MapSet.member?(visited, new_position) do
        new_position
      else
        visited = MapSet.put(visited, new_position)
        calculate_hq_location(moves, new_position, new_facing, visited)
      end
    end
  end

  defp split_moves(moves, {turn, 1}), do: ["#{turn}1" | moves]

  defp split_moves(moves, {turn, length}) do
    split_moves(["S1" | moves], {turn, length - 1})
  end

  @doc """
  iex> Day01.make_turn(:north, "L")
  :east

  iex> Day01.make_turn(:north, "R")
  :west

  iex> Day01.make_turn(:west, "L")
  :north

  iex> Day01.make_turn(:west, "R")
  :south
  """
  def make_turn(facing, turn) do
    do_make_turn(@directions, facing, turn)
  end

  defp do_make_turn(_, facing, "S"), do: facing
  defp do_make_turn([], _facing, "R"), do: List.first(@directions)
  defp do_make_turn([], _facing, "L"), do: List.last(@directions)
  defp do_make_turn([facing, new | _directions], facing, "R"), do: new
  defp do_make_turn([new, facing | _directions], facing, "L"), do: new
  defp do_make_turn([_ | directions], facing, turn), do: do_make_turn(directions, facing, turn)

  defp move({x, y}, :north, length), do: {x, y + length}
  defp move({x, y}, :south, length), do: {x, y - length}
  defp move({x, y}, :east, length), do: {x + length, y}
  defp move({x, y}, :west, length), do: {x - length, y}

  defp parse_input(input) do
    input
    |> String.split(", ")
  end

  def part1_verify, do: input() |> distance()
  def part2_verify, do: input() |> hq_distance()
end

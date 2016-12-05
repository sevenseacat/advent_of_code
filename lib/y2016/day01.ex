defmodule Y2016.Day01 do
  use Advent.Day, no: 1

  @directions [:north, :west, :south, :east]
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
    facing = make_turn(facing, turn)
    position = move(position, facing, length)
    {position, facing}
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
    |> Enum.map(fn <<turn::binary-size(1), length::binary>> ->
      {turn, String.to_integer(length)}
    end)
  end

  def part1_verify, do: input() |> final_distance()
  def part2_verify, do: input() |> hq_distance()
end

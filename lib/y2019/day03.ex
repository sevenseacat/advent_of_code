defmodule Y2019.Day03 do
  use Advent.Day, no: 3

  def part1(wires) do
    [w1_coords, w2_coords] =
      Enum.map(wires, fn wire ->
        calculate_all_coords(wire, {0, 0}, MapSet.new())
      end)

    MapSet.intersection(w1_coords, w2_coords)
    |> Enum.map(fn coord -> {coord, manhattan_distance(coord)} end)
    |> Enum.min_by(fn {_x, dist} -> dist end)
    |> elem(1)
  end

  def part2(_input) do
  end

  def calculate_all_coords([], _, seen), do: seen

  def calculate_all_coords([{direction, distance} | moves], current, seen) do
    {current, seen} = add_moves(direction, distance, current, seen)
    calculate_all_coords(moves, current, seen)
  end

  defp add_moves(dir, distance, current, seen) do
    seen =
      Enum.reduce(1..distance, seen, fn d, acc ->
        MapSet.put(acc, move(dir, d, current))
      end)

    {move(dir, distance, current), seen}
  end

  defp move("L", dist, {x, y}), do: {x - dist, y}
  defp move("U", dist, {x, y}), do: {x, y + dist}
  defp move("R", dist, {x, y}), do: {x + dist, y}
  defp move("D", dist, {x, y}), do: {x, y - dist}

  def manhattan_distance({x, y}), do: abs(x) + abs(y)

  def parse_input(data) do
    data
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&to_move_list/1)
  end

  defp to_move_list(string) do
    string
    |> String.split(",")
    |> Enum.map(&to_move/1)
  end

  def to_move(move) do
    {dir, dist} = String.split_at(move, 1)
    {dir, String.to_integer(dist)}
  end

  def part1_verify, do: input() |> parse_input() |> part1()
end

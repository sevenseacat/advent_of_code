defmodule Y2017.Day19 do
  use Advent.Day, no: 19

  @doc """
  iex> Day19.part1(%{{3, 3} => "-", {12, 5} => "-", {6, 3} => "-", {11, 3} => "|", {5, 1} => "|",
  ...> {14, 4} => "D", {8, 2} => "|", {1, 3} => "F", {11, 2} => "C", {10, 3} => "E",
  ...> {5, 4} => "|", {9, 1} => "-", {7, 5} => "-", {11, 1} => "+", {11, 5} => "+",
  ...> {11, 4} => "|", {13, 5} => "-", {14, 5} => "+", {5, 2} => "A", {9, 3} => "-",
  ...> {12, 3} => "-", {10, 1} => "-", {2, 3} => "-", {8, 1} => "+", {8, 4} => "|",
  ...> {5, 3} => "|", {8, 5} => "+", {6, 5} => "B", {5, 5} => "+", {4, 3} => "-",
  ...> {8, 3} => "-", {13, 3} => "-", {5, 0} => "|", {7, 3} => "-", {14, 3} => "+"})
  "ABCDEF"
  """
  def part1(input) do
    input
    |> find_starting_point
    |> trace_route(:down, input, [], &add_marker(&1, &2))
    |> Enum.reverse()
    |> List.to_string()
  end

  @doc """
  iex> Day19.part2(%{{3, 3} => "-", {12, 5} => "-", {6, 3} => "-", {11, 3} => "|", {5, 1} => "|",
  ...> {14, 4} => "D", {8, 2} => "|", {1, 3} => "F", {11, 2} => "C", {10, 3} => "E",
  ...> {5, 4} => "|", {9, 1} => "-", {7, 5} => "-", {11, 1} => "+", {11, 5} => "+",
  ...> {11, 4} => "|", {13, 5} => "-", {14, 5} => "+", {5, 2} => "A", {9, 3} => "-",
  ...> {12, 3} => "-", {10, 1} => "-", {2, 3} => "-", {8, 1} => "+", {8, 4} => "|",
  ...> {5, 3} => "|", {8, 5} => "+", {6, 5} => "B", {5, 5} => "+", {4, 3} => "-",
  ...> {8, 3} => "-", {13, 3} => "-", {5, 0} => "|", {7, 3} => "-", {14, 3} => "+"})
  38
  """
  def part2(input) do
    input
    |> find_starting_point
    |> trace_route(:down, input, 0, &count(&1, &2))
  end

  defp find_starting_point(input) do
    input
    |> Enum.find(fn {{_, y}, char} -> y == 0 && char == "|" end)
    |> elem(0)
  end

  defp trace_route(coords, direction, input, tracker, func) do
    marker = Map.fetch!(input, coords)

    case next_point(coords, marker, direction, input) do
      nil -> func.(marker, tracker)
      {coords, direction} -> trace_route(coords, direction, input, func.(marker, tracker), func)
    end
  end

  defp next_point(coords, marker, direction, input) do
    if marker == "+" do
      turn(coords, direction, input)
    else
      go_straight(coords, direction, input)
    end
  end

  def turn({x, y}, dir, input) do
    possibles =
      if dir in [:left, :right] do
        [{{x, y + 1}, :down}, {{x, y - 1}, :up}]
      else
        [{{x - 1, y}, :left}, {{x + 1, y}, :right}]
      end

    possibles
    |> Enum.find(fn {coords, _} -> Map.has_key?(input, coords) end)
  end

  def go_straight({x, y}, dir, input) do
    {coords, _} =
      point =
      case dir do
        :left -> {{x - 1, y}, :left}
        :right -> {{x + 1, y}, :right}
        :up -> {{x, y - 1}, :up}
        :down -> {{x, y + 1}, :down}
      end

    if Map.has_key?(input, coords), do: point, else: nil
  end

  defp add_marker(marker, seen) do
    if marker in ["-", "|", "+"], do: seen, else: [marker | seen]
  end

  def count(_, count), do: count + 1

  @doc """
  This returns a map, but maps do not guaranteed key order, so check the sorted value (a list of tuples).

  iex> Day19.input("../../../test/y2017/input/day19") |> Day19.parse_input() |> Enum.sort()
  [{{1, 3}, "F"}, {{2, 3}, "-"}, {{3, 3}, "-"}, {{4, 3}, "-"}, {{5, 0}, "|"},
    {{5, 1}, "|"}, {{5, 2}, "A"}, {{5, 3}, "|"}, {{5, 4}, "|"}, {{5, 5}, "+"},
    {{6, 3}, "-"}, {{6, 5}, "B"}, {{7, 3}, "-"}, {{7, 5}, "-"}, {{8, 1}, "+"},
    {{8, 2}, "|"}, {{8, 3}, "-"}, {{8, 4}, "|"}, {{8, 5}, "+"}, {{9, 1}, "-"},
    {{9, 3}, "-"}, {{10, 1}, "-"}, {{10, 3}, "E"}, {{11, 1}, "+"}, {{11, 2}, "C"},
    {{11, 3}, "|"}, {{11, 4}, "|"}, {{11, 5}, "+"}, {{12, 3}, "-"}, {{12, 5}, "-"},
    {{13, 3}, "-"}, {{13, 5}, "-"}, {{14, 3}, "+"}, {{14, 4}, "D"}, {{14, 5}, "+"}]
  """
  def parse_input(input) do
    input
    |> String.trim_trailing()
    |> String.split("\n")
    |> Enum.reduce({%{}, 0}, fn row, {map, y} ->
      map = row_elems_to_map(map, String.codepoints(row), 0, y)
      {map, y + 1}
    end)
    |> elem(0)
  end

  defp row_elems_to_map(map, [], _, _), do: map

  defp row_elems_to_map(map, [char | chars], x, y) when char == "" or char == " " do
    row_elems_to_map(map, chars, x + 1, y)
  end

  defp row_elems_to_map(map, [char | chars], x, y) do
    map
    |> Map.put({x, y}, char)
    |> row_elems_to_map(chars, x + 1, y)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

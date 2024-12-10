defmodule Y2024.Day10 do
  use Advent.Day, no: 10

  alias Advent.Grid

  def part1({grid, path_grid}) do
    destinations = Enum.filter(grid, &destination?/1)

    grid
    |> Enum.filter(&trailhead?/1)
    |> Task.async_stream(&find_trailhead_score(&1, path_grid, destinations))
    |> Enum.reduce(0, fn {:ok, num}, acc -> acc + num end)
  end

  def part2({grid, path_grid}) do
    destinations = Enum.filter(grid, &destination?/1)

    grid
    |> Enum.filter(&trailhead?/1)
    |> Task.async_stream(&find_trailhead_rating(&1, path_grid, destinations))
    |> Enum.reduce(0, fn {:ok, num}, acc -> acc + num end)
  end

  def parse_input(input) do
    grid = input |> Grid.new() |> Grid.use_number_values()
    {grid, to_path_grid(grid)}
  end

  defp to_path_grid(grid) do
    Enum.reduce(Map.keys(grid), Graph.new(vertex_identifier: & &1), fn from, graph ->
      Enum.reduce(find_valid_movements(grid, from), graph, fn to, graph ->
        graph
        |> Graph.add_vertices([from, to])
        |> Graph.add_edge(from, to)
      end)
    end)
  end

  defp trailhead?({_coord, val}), do: val == 0
  defp destination?({_coord, val}), do: val == 9

  defp find_trailhead_score({coord, _}, path_grid, destinations) do
    Enum.count(destinations, fn {dest_coord, _} ->
      Graph.get_shortest_path(path_grid, coord, dest_coord) != nil
    end)
  end

  defp find_trailhead_rating({coord, _}, path_grid, destinations) do
    Enum.reduce(destinations, 0, fn {dest_coord, _}, count ->
      count + (Graph.get_paths(path_grid, coord, dest_coord) |> length)
    end)
  end

  defp find_valid_movements(map, {row, col}) do
    case Map.get(map, {row, col}) do
      "." ->
        []

      value ->
        [{row + 1, col}, {row - 1, col}, {row, col - 1}, {row, col + 1}]
        |> Enum.filter(fn coord -> Map.get(map, coord) == value + 1 end)
    end
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

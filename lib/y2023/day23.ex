defmodule Y2023.Day23 do
  use Advent.Day, no: 23

  alias Advent.PathGrid

  def part1(%{graph: graph, units: units}) do
    graph
    |> make_one_way_paths(units)
    |> find_longest_path()
  end

  def part2(%{graph: graph}) do
    find_longest_path(graph)
  end

  defp find_longest_path(graph) do
    vertices = PathGrid.floor_spaces(graph)
    {max_row, _col} = PathGrid.size(graph)
    start = Enum.find(vertices, fn {row, _col} -> row == 1 end)
    target = Enum.find(vertices, fn {row, _col} -> row == max_row end)

    take_step([{start, [MapSet.new()]}], %{}, graph, target, 0, 0)
  end

  def add_to_queue(queue, items) do
    Enum.reduce(items, queue, fn {pos, path}, queue ->
      Map.update(queue, pos, [path], &[path | &1])
    end)
  end

  defp take_step([], next, graph, target, current, max) do
    if map_size(next) == 0 do
      max
    else
      # IO.puts("next step #{current + 1} - #{map_size(next)} to check")
      take_step(Enum.to_list(next), %{}, graph, target, current + 1, max)
    end
  end

  defp take_step([{position, paths} | rest], next, graph, target, current, max) do
    if position == target do
      # IO.puts("===---=== new max: #{current} ===---=== ")
      take_step(rest, next, graph, target, current, current)
    else
      next = add_to_queue(next, move(position, graph, paths))
      take_step(rest, next, graph, target, current, max)
    end
  end

  defp move(position, graph, paths) do
    # IO.inspect(length(paths))

    for coord <- Graph.out_neighbors(graph, position), path <- paths do
      {coord, path}
    end
    |> Enum.reject(fn {coord, path} -> MapSet.member?(path, coord) end)
    |> Enum.map(fn {coord, path} ->
      {coord, MapSet.put(path, position)}
    end)
  end

  defp make_one_way_paths(graph, units) do
    units
    |> Enum.reduce(graph, fn %{position: {row, col}} = unit, graph ->
      back =
        case unit.identifier do
          "<" -> {row, col + 1}
          ">" -> {row, col - 1}
          "^" -> {row + 1, col}
          "v" -> {row - 1, col}
        end

      Graph.delete_edge(graph, unit.position, back)
    end)
  end

  def parse_input(input) do
    PathGrid.new(input)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  #  def part2_verify, do: input() |> parse_input() |> part2()
end

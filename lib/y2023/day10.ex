defmodule Y2023.Day10 do
  use Advent.Day, no: 10

  def part1({graph, start}) do
    path = find_path(graph, start)
    div(length(path), 4)
  end

  def part2({graph, start}) do
    # The number of nodes *inside* the loop is the total number of nodes, without
    # the outside nodes and the loop nodes.
    path = find_path(graph, start)
    vertices = Graph.vertices(graph)

    {max_row, _} = Enum.max_by(vertices, &elem(&1, 0))
    max_row = ceil(max_row) + 1
    {_, max_col} = Enum.max_by(vertices, &elem(&1, 1))
    max_col = ceil(max_col) + 1

    is_int? = fn val -> trunc(val) == val end
    set = Enum.map(path, fn {row, col} -> {row * 1.0, col * 1.0} end) |> MapSet.new()

    # You can't do ranges stepping by 0.5?
    # Instead, double the range and then half the values - now everything is a float
    # Start from 0,0 (when row/col starts at 1) so we always have a guaranteed
    # "outside" node to start from
    # Step by 0.5s because we want to have paths going in between two pipes
    non_path_graph =
      for row <- 0..(max_row * 2), col <- 0..(max_col * 2) do
        {row / 2, col / 2}
      end
      |> Enum.reduce(Graph.new(), fn {row, col}, graph ->
        if MapSet.member?(set, {row, col}) do
          graph
        else
          graph
          |> Graph.add_vertex({row, col})
          |> maybe_add_edge({row, col}, {row - 0.5, col})
          |> maybe_add_edge({row, col}, {row, col - 0.5})
        end
      end)

    outside =
      Graph.reachable(non_path_graph, [{0.0, 0.0}])
      |> Enum.filter(fn {row, col} ->
        # Not really integers - just x.0 float values
        is_int?.(row) && is_int?.(col)
      end)

    (max_row + 1) * (max_col + 1) - length(outside) - div(length(path), 2)
  end

  defp maybe_add_edge(graph, from, to) do
    if Graph.has_vertex?(graph, to) do
      graph
      |> Graph.add_edge(from, to)
      |> Graph.add_edge(to, from)
    else
      graph
    end
  end

  defp find_path(graph, {row, col}) do
    # We know the animal position - the pipe at S is actually one of the other
    # letters so we could actually be starting at the square above, below, left
    # right of the start, and trying to get back to the start
    path =
      [{row - 0.5, col}, {row + 0.5, col}, {row, col - 0.5}, {row, col + 0.5}]
      |> Enum.flat_map(fn position ->
        # Find the path from the new start back to the original position
        [
          Graph.dijkstra(graph, position, {row - 0.5, col}),
          Graph.dijkstra(graph, position, {row + 0.5, col}),
          Graph.dijkstra(graph, position, {row, col - 0.5}),
          Graph.dijkstra(graph, position, {row, col + 0.5})
        ]
      end)
      |> Enum.filter(fn path -> path end)
      |> Enum.max_by(fn path -> length(path) end)

    [{row, col} | path]
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index(1)
    |> Enum.reduce({Graph.new(), nil}, &parse_row/2)
  end

  defp parse_row({row, row_no}, acc) do
    row
    |> String.graphemes()
    |> Enum.with_index(1)
    |> Enum.reduce(acc, fn {char, col_no}, {graph, start} ->
      position = {row_no, col_no}
      joined_to = get_join_positions(char, position)
      start = if char == "S", do: position, else: start

      graph =
        joined_to
        |> Enum.reduce(graph, fn join, graph ->
          graph
          |> Graph.add_edge(join, position)
          |> Graph.add_edge(position, join)
        end)

      {graph, start}
    end)
  end

  defp get_join_positions(char, {row, col}) do
    case char do
      "|" -> [{row - 0.5, col}, {row + 0.5, col}]
      "-" -> [{row, col - 0.5}, {row, col + 0.5}]
      "L" -> [{row - 0.5, col}, {row, col + 0.5}]
      "J" -> [{row, col - 0.5}, {row - 0.5, col}]
      "7" -> [{row, col - 0.5}, {row + 0.5, col}]
      "F" -> [{row + 0.5, col}, {row, col + 0.5}]
      _ -> []
    end
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

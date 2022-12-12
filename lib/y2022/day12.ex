defmodule Y2022.Day12 do
  use Advent.Day, no: 12

  def part1({graph, {from, to}}) do
    case Graph.Pathfinding.dijkstra(graph, from, to) do
      nil -> nil
      list -> length(list) - 1
    end
  end

  def part2({graph, {_, to}}) do
    graph
    |> Graph.vertices()
    |> Enum.filter(fn vertex -> Graph.vertex_labels(graph, vertex) == [?a] end)
    |> Enum.map(fn vertex -> part1({graph, {vertex, to}}) end)
    |> Enum.min()
  end

  def parse_input(input) do
    {graph, ends, _} =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce({Graph.new(), {nil, nil}, 1}, &parse_row/2)

    {graph, ends}
  end

  defp parse_row(row, {graph, ends, row_num}) do
    {graph, ends, _} =
      row
      |> String.to_charlist()
      |> Enum.reduce({graph, ends, 1}, fn char, {graph, ends, col_num} ->
        elevation = to_elevation(char)

        graph =
          graph
          |> Graph.add_vertex({row_num, col_num}, elevation)
          |> maybe_add_edges({{row_num, col_num}, elevation}, {row_num - 1, col_num})
          |> maybe_add_edges({{row_num, col_num}, elevation}, {row_num, col_num - 1})

        {graph, maybe_update_ends(char, {row_num, col_num}, ends), col_num + 1}
      end)

    {graph, ends, row_num + 1}
  end

  defp maybe_update_ends(?S, coord, {_from, to}), do: {coord, to}
  defp maybe_update_ends(?E, coord, {from, _to}), do: {from, coord}
  defp maybe_update_ends(_char, _coord, ends), do: ends

  defp to_elevation(?S), do: ?a
  defp to_elevation(?E), do: ?z
  defp to_elevation(char), do: char

  defp maybe_add_edges(graph, coord, adjacent) do
    case Graph.vertex_labels(graph, adjacent) do
      [] ->
        graph

      [adjacent_val] ->
        adjacent = {adjacent, adjacent_val}

        graph
        |> add_edge_if_lower(coord, adjacent)
        |> add_edge_if_lower(adjacent, coord)
    end
  end

  defp add_edge_if_lower(graph, {coord1, coord1_val}, {coord2, coord2_val}) do
    if coord2_val <= coord1_val + 1 do
      Graph.add_edge(graph, coord1, coord2)
    else
      graph
    end
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

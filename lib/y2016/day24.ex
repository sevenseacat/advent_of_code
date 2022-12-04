defmodule Y2016.Day24 do
  use Advent.Day, no: 24

  def part1({graph, units}) do
    targets = Map.keys(units) -- [0]

    targets
    |> Advent.permutations(length(targets))
    |> Enum.reduce({[], %{}}, fn order, {data, cache} ->
      order = [0 | order]
      {distance, cache} = distance(graph, units, order, cache)
      {[{order, distance} | data], cache}
    end)
    |> elem(0)
    |> Enum.min_by(fn {_order, distance} -> distance end)
  end

  defp distance(graph, units, order, cache) do
    order
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce({0, cache}, fn [from, to], {sum, cache} ->
      {length, cache} =
        case Map.get(cache, [from, to]) do
          nil ->
            length = length(Graph.dijkstra(graph, units[from], units[to])) - 1
            cache = Map.put(cache, [from, to], length)

            {length, cache}

          val ->
            {val, cache}
        end

      {sum + length, cache}
    end)
  end

  def parse_input(input) do
    {graph, units, _row} =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce({Graph.new(), %{}, 1}, &parse_row/2)

    {graph, units}
  end

  defp parse_row(row, {graph, units, row_num}) do
    {graph, units, _col_num} =
      row
      |> String.graphemes()
      |> Enum.reduce({graph, units, 1}, fn char, {graph, units, col_num} ->
        units = parse_unit(char, units, row_num, col_num)
        graph = parse_coord(char, graph, row_num, col_num)
        {graph, units, col_num + 1}
      end)

    {graph, units, row_num + 1}
  end

  defp parse_unit("#", units, _row, _col), do: units
  defp parse_unit(".", units, _row, _col), do: units
  defp parse_unit(unit, units, row, col), do: Map.put(units, String.to_integer(unit), {row, col})

  defp parse_coord("#", graph, _, _), do: graph

  defp parse_coord(_, graph, row, col) do
    graph = Graph.add_vertex(graph, {row, col})

    [{row - 1, col}, {row, col - 1}]
    |> Enum.reduce(graph, fn neighbour, graph ->
      if Graph.has_vertex?(graph, neighbour) do
        graph
        |> Graph.add_edge({row, col}, neighbour)
        |> Graph.add_edge(neighbour, {row, col})
      else
        graph
      end
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1() |> elem(1)
end

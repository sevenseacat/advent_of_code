defmodule Y2021.Day15 do
  use Advent.Day, no: 15

  def part1(input) do
    {to_row, to_col} = find_max(input)

    input
    |> build_graph()
    |> Graph.dijkstra({0, 0}, {to_row, to_col})
    |> get_score(input)
  end

  def part2(input) do
    max = find_max(input)

    input
    |> grow_input(max, {5, 5})
    |> part1()
  end

  def grow_input(input, {max_row, max_col}, {row_mult, col_mult}) do
    for row_offset <- 0..(row_mult - 1), col_offset <- 0..(col_mult - 1) do
      Enum.reduce(input, Map.new(), fn {{row, col}, val}, acc ->
        Map.put(
          acc,
          {row + row_offset * (max_row + 1), col + col_offset * (max_col + 1)},
          wrap(val + row_offset + col_offset)
        )
      end)
    end
    |> Enum.reduce(Map.new(), fn x, acc -> Map.merge(x, acc) end)
  end

  defp wrap(val), do: if(val > 9, do: val - 9, else: val)

  defp find_max(input) do
    {{max_row, _}, _} = Enum.max_by(input, fn {{row, _}, _} -> row end)
    {{_, max_col}, _} = Enum.max_by(input, fn {{_, col}, _} -> col end)

    {max_row, max_col}
  end

  defp build_graph(input) do
    input
    |> Enum.reduce(Graph.new(), fn {{row, col} = from, from_weight}, graph ->
      [{row + 1, col}, {row, col + 1}]
      |> Enum.reduce(graph, fn to_coord, graph ->
        to_weight = Map.get(input, to_coord)
        maybe_add_edge(graph, from, from_weight, to_coord, to_weight)
      end)
    end)
  end

  defp maybe_add_edge(graph, _from, _from_weight, _to, nil), do: graph

  defp maybe_add_edge(graph, from, from_weight, to, to_weight) do
    graph
    |> Graph.add_edge(from, to, weight: to_weight)
    |> Graph.add_edge(to, from, weight: from_weight)
  end

  defp get_score([_start | path], input) do
    Enum.reduce(path, 0, fn coord, acc -> acc + Map.get(input, coord) end)
  end

  @doc """
  iex> Day15.parse_input("123\\n456\\n")
  %{{0,0} => 1, {0,1} => 2, {0,2} => 3, {1,0} => 4, {1,1} => 5, {1,2} => 6}
  """
  def parse_input(input) do
    lines = String.split(input, "\n", trim: true)

    for {line, row} <- Enum.with_index(lines),
        {value, col} <- Enum.with_index(String.graphemes(line)),
        into: %{} do
      {{row, col}, String.to_integer(value)}
    end
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

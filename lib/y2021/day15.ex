defmodule Y2021.Day15 do
  use Advent.Day, no: 15

  def part1(input) do
    {to_row, to_col} = find_target(input)

    input
    |> build_graph()
    |> Graph.dijkstra({0, 0}, {to_row, to_col})
    |> get_score(input)
  end

  defp find_target(input) do
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
end

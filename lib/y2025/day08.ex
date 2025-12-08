defmodule Y2025.Day08 do
  use Advent.Day, no: 08

  def part1(input, num_joins \\ 10) do
    graph = to_bare_graph(input)
    distances = compute_all_distances(input)
    connected = MapSet.new(input)

    join_boxes(graph, distances, connected, num_joins)
    |> Graph.components()
    |> Enum.sort_by(&(-length(&1)))
    |> Enum.take(3)
    |> Enum.reduce(1, fn set, acc -> set |> length() |> Kernel.*(acc) end)
  end

  def part2(input) do
    graph = to_bare_graph(input)
    distances = compute_all_distances(input)
    connected = MapSet.new(input)

    {{x1, _, _}, {x2, _, _}} = join_boxes(graph, distances, connected, 100_000)

    x1 * x2
  end

  defp to_bare_graph(boxes) do
    Enum.reduce(boxes, Graph.new(), fn node, graph -> Graph.add_vertex(graph, node) end)
  end

  defp compute_all_distances(boxes) do
    Advent.combinations(boxes, 2)
    |> Enum.map(fn [one, two] -> {one, two, distance(one, two)} end)
    |> Enum.sort_by(fn {_, _, distance} -> distance end)
  end

  defp join_boxes(graph, _distances, _connected, 0), do: graph

  defp join_boxes(graph, [{from, to, _} | distances], connected, count) do
    graph = join_groups(graph, from, to)

    connected =
      connected
      |> MapSet.delete(from)
      |> MapSet.delete(to)

    if MapSet.size(connected) == 0 do
      {from, to}
    else
      join_boxes(graph, distances, connected, count - 1)
    end
  end

  defp distance({x1, y1, z1}, {x2, y2, z2}) do
    :math.sqrt(:math.pow(x1 - x2, 2) + :math.pow(y1 - y2, 2) + :math.pow(z1 - z2, 2))
  end

  defp join_groups(graph, one, two) do
    graph
    |> Graph.add_edge(one, two)
    |> Graph.add_edge(two, one)
  end

  @doc """
  iex> Day08.parse_input("162,817,812\\n57,618,57\\n")
  [{162,817,812}, {57,618,57}]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1(1000)
  def part2_verify, do: input() |> parse_input() |> part2()
end

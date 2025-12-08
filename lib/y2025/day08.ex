defmodule Y2025.Day08 do
  use Advent.Day, no: 08

  def part1(input, num_joins \\ 10) do
    graph = to_bare_graph(input)

    join_boxes(input, graph, num_joins)
    |> Graph.components()
    |> Enum.sort_by(&(-length(&1)))
    |> Enum.take(3)
    |> Enum.reduce(1, fn set, acc -> set |> length() |> Kernel.*(acc) end)
  end

  def part2(input) do
    graph = to_bare_graph(input)

    {{x1, _, _}, {x2, _, _}} = join_boxes(input, graph, 100_000_000)

    x1 * x2
  end

  defp to_bare_graph(boxes) do
    Enum.reduce(boxes, Graph.new(), fn node, graph -> Graph.add_vertex(graph, node) end)
  end

  defp join_boxes(_boxes, graph, 0), do: graph

  defp join_boxes(boxes, graph, count) do
    {from, to, _distance} =
      Enum.map(boxes, fn box ->
        {closest, distance} = find_closest(box, boxes, graph)
        {box, closest, distance}
      end)
      |> Enum.min_by(fn {_from, _to, distance} -> distance end)

    graph = join_groups(graph, from, to)

    if length(Graph.components(graph)) == 1 do
      {from, to}
    else
      join_boxes(boxes, graph, count - 1)
    end
  end

  defp find_closest(from, boxes, graph) do
    connected = Graph.neighbors(graph, from)

    boxes
    |> Enum.reject(fn box -> box == from || box in connected end)
    |> Enum.map(fn to = box -> {box, distance(from, to)} end)
    |> Enum.min_by(fn {_box, distance} -> distance end)
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

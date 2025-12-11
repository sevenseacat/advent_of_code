defmodule Y2025.Day11 do
  use Advent.Day, no: 11

  def part1(input) do
    input
    |> build_graph()
    |> Graph.get_paths("you", "out")
    |> length()
  end

  def part2(input) do
    graph = build_graph(input)

    # There are no paths from dac -> fft in either the sample or real input
    # so we don't need to search svr -> dac -> fft -> out
    # only svr -> fft -> dac -> out
    [{"svr", "fft"}, {"fft", "dac"}, {"dac", "out"}]
    |> Advent.pmap(fn pair -> count_paths_between(pair, graph) end)
    |> Enum.product()
  end

  def build_graph(input) do
    Enum.reduce(input, Graph.new(vertex_identifier: & &1), fn {input, outputs}, graph ->
      Enum.reduce(outputs, graph, fn output, graph ->
        Graph.add_edge(graph, input, output)
      end)
    end)
  end

  def count_paths_between({from, to}, graph) do
    steps = Graph.get_shortest_path(graph, from, to) |> length()

    run_bfs([{from, 1}], %{}, graph, to, 0, steps + 3, %{})
  end

  # A couple of end states - we've stepped too far, or we've run out of states to check
  defp run_bfs([], next_tier, _graph, to, _step, _max_steps, state)
       when map_size(next_tier) == 0 do
    state[to]
  end

  defp run_bfs(_, _, _graph, to, step, max_steps, state) when step > max_steps do
    state[to]
  end

  defp run_bfs([], next_tier, graph, to, step, max_steps, state) do
    run_bfs(Map.to_list(next_tier), %{}, graph, to, step + 1, max_steps, state)
  end

  defp run_bfs([{node, count} | next], next_tier, graph, to, step, max_steps, state) do
    # Add the next tier of nodes
    nodes = Graph.out_neighbors(graph, node)

    next_tier =
      Enum.reduce(nodes, next_tier, fn node, acc ->
        Map.update(acc, node, count, &(&1 + count))
      end)

    run_bfs(
      next,
      next_tier,
      graph,
      to,
      step,
      max_steps,
      Map.update(state, node, count, &(&1 + count))
    )
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Map.new(&parse_row/1)
  end

  defp parse_row(row) do
    [input, outputs] = String.split(row, ": ")
    outputs = String.split(outputs, " ")
    {input, outputs}
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

defmodule Y2024.Day23 do
  use Advent.Day, no: 23

  def part1(graph) do
    graph
    |> Graph.cliques()
    |> Enum.filter(fn clique -> length(clique) >= 3 end)
    |> Enum.flat_map(fn clique ->
      Advent.combinations(clique, 3)
      |> Enum.filter(fn clique -> Enum.any?(clique, &t?/1) end)
    end)
    |> Enum.uniq()
    |> length()
  end

  def part2(graph) do
    graph
    |> Graph.cliques()
    |> Enum.max_by(&length/1)
    |> Enum.sort()
    |> Enum.join(",")
  end

  defp t?(str), do: String.starts_with?(str, "t")

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.reduce(Graph.new(type: :undirected), fn [from, to], graph ->
      Graph.add_edge(graph, from, to)
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

defmodule Y2024.Day23 do
  use Advent.Day, no: 23

  def part1(graph) do
    graph
    |> Graph.vertices()
    |> Enum.filter(&String.starts_with?(&1, "t"))
    |> Enum.reduce([], fn one, acc ->
      Graph.out_neighbors(graph, one)
      |> Enum.reduce(acc, fn two, acc ->
        Graph.out_neighbors(graph, two)
        |> Enum.reduce(acc, fn three, acc ->
          if Graph.edge(graph, three, one) do
            [[one, two, three] | acc]
          else
            acc
          end
        end)
      end)
    end)
    |> Enum.map(&Enum.sort/1)
    |> Enum.uniq()
    |> length()
  end

  # @doc """
  # iex> Day23.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.reduce(Graph.new(), fn [from, to], graph ->
      Graph.add_edges(graph, [{from, to}, {to, from}])
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end

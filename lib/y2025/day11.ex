defmodule Y2025.Day11 do
  use Advent.Day, no: 11

  def part1(input) do
    input
    |> Enum.reduce(Graph.new(), fn {input, outputs}, graph ->
      Enum.reduce(outputs, graph, fn output, graph ->
        Graph.add_edge(graph, input, output)
      end)
    end)
    |> Graph.get_paths("you", "out")
    |> length()
  end

  # @doc """
  # iex> Day11.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

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
  # def part2_verify, do: input() |> parse_input() |> part2()
end

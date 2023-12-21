defmodule Y2023.Day21 do
  use Advent.Day, no: 21

  alias Advent.PathGrid

  def part1(%{graph: graph, units: [start]}, steps \\ 64) do
    take_step(graph, [{start.position, 1}], %{}, steps)
    |> length()
  end

  # @doc """
  # iex> Day21.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp take_step(_graph, data, %{}, 0), do: data

  defp take_step(graph, [], queue, steps) do
    take_step(graph, Enum.to_list(queue), %{}, steps - 1)
  end

  defp take_step(graph, [{position, count} | rest], queue, steps) do
    moves = move(position, graph)
    queue = add_to_queue(queue, moves, count)
    take_step(graph, rest, queue, steps)
  end

  defp move(position, graph) do
    graph
    |> Graph.neighbors(position)
    |> Enum.filter(&PathGrid.floor?(graph, &1))
  end

  defp add_to_queue(queue, moves, count) do
    Enum.reduce(moves, queue, fn move, queue ->
      Map.update(queue, move, count, &(&1 + count))
    end)
  end

  def parse_input(input) do
    PathGrid.new(input)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end

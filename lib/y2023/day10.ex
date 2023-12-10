defmodule Y2023.Day10 do
  use Advent.Day, no: 10

  def part1({graph, {row, col}}) do
    # We know the animal position - the pipe at S is actually one of the other
    # letters so we could actually be starting at the square above, below, left
    # right of the start, and trying to get back to the start
    path =
      [{row - 0.5, col}, {row + 0.5, col}, {row, col - 0.5}, {row, col + 0.5}]
      # |> Enum.filter(fn position -> )
      |> Enum.flat_map(fn position ->
        # Find the path from the new start back to the original position
        [
          {position, Graph.dijkstra(graph, position, {row - 0.5, col})},
          {position, Graph.dijkstra(graph, position, {row + 0.5, col})},
          {position, Graph.dijkstra(graph, position, {row, col - 0.5})},
          {position, Graph.dijkstra(graph, position, {row, col + 0.5})}
        ]
      end)
      |> Enum.filter(fn {_position, path} -> path end)
      |> Enum.max_by(fn {_position, path} -> length(path) end)
      |> elem(1)

    div(length(path) + 1, 4)
  end

  # @doc """
  # iex> Day10.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index(1)
    |> Enum.reduce({Graph.new(), nil}, &parse_row/2)
  end

  defp parse_row({row, row_no}, acc) do
    row
    |> String.graphemes()
    |> Enum.with_index(1)
    |> Enum.reduce(acc, fn {char, col_no}, {graph, start} ->
      position = {row_no, col_no}
      joined_to = get_join_positions(char, position)
      start = if char == "S", do: position, else: start

      graph =
        joined_to
        |> Enum.reduce(graph, fn join, graph ->
          graph
          |> Graph.add_edge(join, position)
          |> Graph.add_edge(position, join)
        end)

      {graph, start}
    end)
  end

  defp get_join_positions(char, {row, col}) do
    case char do
      "|" -> [{row - 0.5, col}, {row + 0.5, col}]
      "-" -> [{row, col - 0.5}, {row, col + 0.5}]
      "L" -> [{row - 0.5, col}, {row, col + 0.5}]
      "J" -> [{row, col - 0.5}, {row - 0.5, col}]
      "7" -> [{row, col - 0.5}, {row + 0.5, col}]
      "F" -> [{row + 0.5, col}, {row, col + 0.5}]
      _ -> []
    end
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end

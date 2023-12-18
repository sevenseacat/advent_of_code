defmodule Y2023.Day18 do
  use Advent.Day, no: 18

  def part1(input) do
    {_pos, border} = Enum.reduce(input, {{1, 1}, %{{1, 1} => []}}, &dig_trench/2)
    {{min_row, min_col}, {max_row, max_col}} = Advent.Grid.corners(border)

    non_path_graph =
      for row <- (min_row - 1)..(max_row + 1), col <- (min_col - 1)..(max_col + 1) do
        {row, col}
      end
      |> Enum.reduce(Graph.new(vertex_identifier: & &1), fn {row, col}, graph ->
        if Map.has_key?(border, {row, col}) do
          graph
        else
          graph
          |> Graph.add_vertex({row, col})
          |> maybe_add_edge({row, col}, {row - 1, col})
          |> maybe_add_edge({row, col}, {row, col - 1})
        end
      end)

    outside = Graph.reachable(non_path_graph, [{min_row - 1, min_col - 1}])

    (max_row + 3 - min_row) * (max_col + 3 - min_col) - length(outside)
  end

  # @doc """
  # iex> Day18.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp maybe_add_edge(graph, from, to) do
    if Graph.has_vertex?(graph, to) do
      graph
      |> Graph.add_edge(from, to)
      |> Graph.add_edge(to, from)
    else
      graph
    end
  end

  defp dig_trench({direction, length, color}, acc) do
    Enum.reduce(1..length, acc, fn _, {position, map} ->
      new_position = move(position, direction)
      map = Map.update(map, new_position, [color], &[color | &1])
      {new_position, map}
    end)
  end

  defp move({row, col}, direction) do
    case direction do
      "D" -> {row + 1, col}
      "U" -> {row - 1, col}
      "L" -> {row, col - 1}
      "R" -> {row, col + 1}
    end
  end

  @doc """
  iex> Day18.parse_input("R 6 (#70c710)\\nD 15 (#0dc571)")
  [{"R", 6, "#70c710"}, {"D", 15, "#0dc571"}]
  """
  def parse_input(input) do
    for row <- String.split(input, "\n", trim: true) do
      [direction, length, color] = String.split(row, " ")
      color = String.replace(color, ["(", ")"], "")
      {direction, String.to_integer(length), color}
    end
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end

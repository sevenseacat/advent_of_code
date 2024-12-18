defmodule Y2024.Day18 do
  use Advent.Day, no: 18

  alias Advent.PathGrid

  def part1(bytes, size \\ 50, byte_num \\ 1024) do
    fallen = Enum.take(bytes, byte_num)

    graph =
      Enum.reduce(fallen, empty_grid({0, 0}, {size, size}), fn coord, graph ->
        PathGrid.add_wall(graph, coord)
      end)

    length(Graph.get_shortest_path(graph, {0, 0}, {size, size})) - 1
  end

  # @doc """
  # iex> Day18.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  @doc """
  iex> Day18.parse_input("5,4\\n4,2\\n4,5\\n3,0\\n")
  [{5,4}, {4,2}, {4,5}, {3,0}]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [left, right] = String.split(line, ",", parts: 2)
      {String.to_integer(left), String.to_integer(right)}
    end)
  end

  @doc """
  Create a completely empty path grid of a given size.
  """
  def empty_grid({from_row, from_col}, {to_row, to_col}) do
    Enum.reduce(from_row..to_row, Graph.new(vertex_identifier: & &1), fn row, graph ->
      Enum.reduce(from_col..to_col, graph, fn col, graph ->
        graph = Graph.add_vertex(graph, {row, col}, :floor)

        [{row - 1, col}, {row, col - 1}]
        |> Enum.reduce(graph, fn neighbour, graph ->
          if PathGrid.floor?(graph, neighbour) do
            graph
            |> Graph.add_edge({row, col}, neighbour)
            |> Graph.add_edge(neighbour, {row, col})
          else
            graph
          end
        end)
      end)
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1(70, 1024)
  # def part2_verify, do: input() |> parse_input() |> part2()
end

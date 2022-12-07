defmodule Y2019.Day17 do
  use Advent.Day, no: 17

  alias Advent.Grid
  alias Y2019.Intcode

  def part1(input) do
    input
    |> flip_symbols
    |> Grid.new()
    |> find_intersections()
    |> to_alignment_parameter()
  end

  defp find_intersections(%Grid{graph: graph}) do
    vertices = MapSet.new(Graph.vertices(graph))

    vertices
    |> Enum.filter(fn {x, y} ->
      [{x - 1, y}, {x, y - 1}, {x + 1, y}, {x, y + 1}]
      |> Enum.all?(fn coord -> MapSet.member?(vertices, coord) end)
    end)
  end

  defp to_alignment_parameter(list) do
    Enum.reduce(list, 0, fn {x, y}, acc -> acc + (x - 1) * (y - 1) end)
  end

  defp parse_input(input) do
    input
    |> Intcode.from_string()
    |> Intcode.new()
    |> Intcode.run()
    |> Intcode.outputs()
    |> to_string
  end

  defp flip_symbols(input) do
    input
    # random third character
    |> String.replace(".", "x")
    |> String.replace("#", ".")
    |> String.replace("x", "#")
  end

  def part1_verify, do: input() |> parse_input() |> part1()
end

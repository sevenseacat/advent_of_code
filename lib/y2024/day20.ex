defmodule Y2024.Day20 do
  use Advent.Day, no: 20

  alias Advent.PathGrid

  def part1(input) do
    input
    |> cheats
    |> Enum.reduce(0, fn {saving, count}, acc ->
      if saving >= 100, do: acc + count, else: acc
    end)
  end

  # @doc """
  # iex> Day20.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  def cheats({graph, from, to}) do
    baseline = Graph.get_shortest_path(graph, from, to) |> MapSet.new()
    baseline_length = MapSet.size(baseline)

    PathGrid.wall_spaces(graph)
    |> Enum.filter(fn coord ->
      neighbours = PathGrid.neighbouring_coords(coord)

      Enum.any?(neighbours, &MapSet.member?(baseline, &1)) &&
        Enum.count(PathGrid.neighbouring_coords(coord), fn coord ->
          PathGrid.floor?(graph, coord)
        end) >= 2
    end)
    |> Task.async_stream(fn coord ->
      path =
        graph
        |> PathGrid.remove_wall(coord)
        |> Graph.get_shortest_path(from, to)

      baseline_length - length(path)
    end)
    |> Enum.map(fn {:ok, val} -> val end)
    |> Enum.reject(&(&1 == 0))
    |> Enum.frequencies()
  end

  def parse_input(input) do
    grid = PathGrid.new(input)
    from = Enum.find(grid.units, &(&1.identifier == "S")) |> Map.get(:position)
    to = Enum.find(grid.units, &(&1.identifier == "E")) |> Map.get(:position)

    {grid.graph, from, to}
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end

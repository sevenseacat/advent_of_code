defmodule Y2022.Day18 do
  use Advent.Day, no: 18

  @adjacents [[-1, 0, 0], [1, 0, 0], [0, -1, 0], [0, 1, 0], [0, 0, -1], [0, 0, 1]]

  def part1(input) do
    surface_area(input)
  end

  def part2(input) do
    {min_x, max_x} = Enum.map(input, &Enum.at(&1, 0)) |> Enum.min_max()
    {min_y, max_y} = Enum.map(input, &Enum.at(&1, 1)) |> Enum.min_max()
    {min_z, max_z} = Enum.map(input, &Enum.at(&1, 2)) |> Enum.min_max()

    air_coords =
      for(
        x <- (min_x - 1)..(max_x + 1),
        y <- (min_y - 1)..(max_y + 1),
        z <- (min_z - 1)..(max_z + 1),
        do: [x, y, z]
      )
      |> MapSet.new()
      |> MapSet.difference(MapSet.new(input))

    graph =
      Enum.reduce(air_coords, Graph.new(), fn [x, y, z] = coord, graph ->
        graph = Graph.add_vertex(graph, coord)

        Enum.reduce(@adjacents, graph, fn [a, b, c], graph ->
          adjacent = [x + a, y + b, z + c]

          if MapSet.member?(air_coords, adjacent) do
            graph
            |> Graph.add_vertex(adjacent)
            |> Graph.add_edge(coord, adjacent)
            |> Graph.add_edge(adjacent, coord)
          else
            graph
          end
        end)
      end)

    # Graph is an interconnected graph of all of the *air bubbles* cubes.
    # If there's no path between the air bubble and one corner of the graph, then
    # it's part of an internal air bubble.
    # Then we can work out the surface area of all of those cubes and subtract.
    external_cubes = MapSet.new(Graph.reachable(graph, [[min_x, min_y, min_z]]))

    internal_surface_area =
      MapSet.difference(air_coords, external_cubes)
      |> surface_area()

    surface_area(input) - internal_surface_area
  end

  defp surface_area(cubes) do
    cubes
    |> Enum.map(&count_exposed_sides(&1, MapSet.new(cubes)))
    |> Enum.sum()
  end

  defp count_exposed_sides([x, y, z], input) do
    # The number of exposed sides for this cube will be 6 - the number of adjacent cubes
    adjacents =
      Enum.map(@adjacents, fn [a, b, c] -> [x + a, y + b, z + c] end)
      |> Enum.count(fn adjacent -> MapSet.member?(input, adjacent) end)

    6 - adjacents
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      Regex.run(~r/^(\d+),(\d+),(\d+)$/, row, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

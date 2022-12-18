defmodule Y2020.Day17 do
  use Advent.Day, no: 17
  alias Advent.Grid

  @adjacents_3d for x <- -1..1, y <- -1..1, z <- -1..1, [x, y, z] != [0, 0, 0], do: [x, y, z]
  @adjacents_4d for x <- -1..1,
                    y <- -1..1,
                    z <- -1..1,
                    w <- -1..1,
                    [x, y, z, w] != [0, 0, 0, 0],
                    do: [x, y, z, w]

  def parts(input, dimension) do
    {{min_x, _}, {max_x, _}} = Map.keys(input) |> Enum.min_max_by(&elem(&1, 0))
    {{_, min_y}, {_, max_y}} = Map.keys(input) |> Enum.min_max_by(&elem(&1, 1))

    input = grow_to_dimension(input, dimension)
    do_rounds(input, 6, dimension, {{min_x, max_x}, {min_y, max_y}, {0, 0}})
  end

  defp do_rounds(grid, 0, _dimension, _ranges) do
    grid |> Map.values() |> Enum.count(fn v -> v == "#" end)
  end

  defp do_rounds(grid, round, dimension, ranges) do
    ranges = expand_ranges(ranges)

    ranges
    |> coords_in_range(dimension)
    |> Enum.reduce(Map.new(), fn coord, acc ->
      current = Map.get(grid, coord, ".")
      active_adjacent = get_adjacents(coord, grid) |> Enum.count(fn v -> v == "#" end)

      new_val =
        case {current, active_adjacent} do
          {"#", num} when num in [2, 3] -> "#"
          {"#", _} -> "."
          {".", 3} -> "#"
          {".", _} -> "."
        end

      Map.put(acc, coord, new_val)
    end)
    |> do_rounds(round - 1, dimension, ranges)
  end

  defp coords_in_range({{x1, x2}, {y1, y2}, {z1, z2}}, 3) do
    for x <- x1..x2, y <- y1..y2, z <- z1..z2, do: [x, y, z]
  end

  defp coords_in_range({{x1, x2}, {y1, y2}, {z1, z2}}, 4) do
    for x <- x1..x2, y <- y1..y2, z <- z1..z2, w <- z1..z2, do: [x, y, z, w]
  end

  defp expand_ranges({xs, ys, zs}), do: {expand_range(xs), expand_range(ys), expand_range(zs)}
  defp expand_range({from, to}), do: {from - 1, to + 1}

  defp get_adjacents(coord, grid) when length(coord) == 4 do
    do_get_adjacents(coord, @adjacents_4d, grid)
  end

  defp get_adjacents(coord, grid) when length(coord) == 3 do
    do_get_adjacents(coord, @adjacents_3d, grid)
  end

  defp do_get_adjacents(coord, adjacents, grid) do
    Enum.map(adjacents, fn adjacent ->
      adjacent_coord = Enum.zip([coord, adjacent]) |> Enum.map(fn {a, b} -> a + b end)
      Map.get(grid, adjacent_coord, ".")
    end)
  end

  def parse_input(input), do: Grid.new(input)

  defp grow_to_dimension(input, dimension) do
    Enum.reduce(input, Map.new(), fn {{row, col}, val}, acc ->
      Map.put(acc, [row, col | List.duplicate(0, dimension - 2)], val)
    end)
  end

  def part1_verify, do: input() |> parse_input() |> parts(3)
  def part2_verify, do: input() |> parse_input() |> parts(4)
end

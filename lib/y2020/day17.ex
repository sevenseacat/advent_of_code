defmodule Y2020.Day17 do
  use Advent.Day, no: 17
  alias Advent.Grid

  @adjacents for x <- -1..1, y <- -1..1, z <- -1..1, {x, y, z} != {0, 0, 0}, do: {x, y, z}

  def part1(input, rounds \\ 6) do
    {{min_x, _, _}, {max_x, _, _}} = Map.keys(input) |> Enum.min_max_by(&elem(&1, 0))
    {{_, min_y, _}, {_, max_y, _}} = Map.keys(input) |> Enum.min_max_by(&elem(&1, 1))

    do_rounds(input, rounds, {{min_x, max_x}, {min_y, max_y}, {0, 0}})
  end

  # @doc """
  # iex> Day17.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp do_rounds(grid, 0, _ranges) do
    grid |> Map.values() |> Enum.count(fn v -> v == "#" end)
  end

  defp do_rounds(grid, round, ranges) do
    ranges = expand_ranges(ranges)

    ranges
    |> coords_in_range()
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
    |> do_rounds(round - 1, ranges)
  end

  defp coords_in_range({{x1, x2}, {y1, y2}, {z1, z2}}) do
    for x <- x1..x2, y <- y1..y2, z <- z1..z2, do: {x, y, z}
  end

  defp expand_ranges({xs, ys, zs}), do: {expand_range(xs), expand_range(ys), expand_range(zs)}
  defp expand_range({from, to}), do: {from - 1, to + 1}

  defp get_adjacents({x, y, z}, grid) do
    Enum.map(@adjacents, fn {a, b, c} ->
      Map.get(grid, {x + a, y + b, z + c}, ".")
    end)
  end

  def parse_input(input) do
    # This makes a 2D grid
    Grid.new(input)
    # But ours is 3D, so pretend it's at z=0
    |> Enum.reduce(Map.new(), fn {{row, col}, val}, acc ->
      Map.put(acc, {row, col, 0}, val)
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end

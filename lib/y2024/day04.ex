defmodule Y2024.Day04 do
  use Advent.Day, no: 04

  def part1(input) do
    input
    |> find_coords("X")
    |> Enum.flat_map(&find_xmas_words(input, &1))
    |> length()
  end

  def part2(input) do
    input
    |> find_coords("A")
    |> Enum.flat_map(&find_x_mas_words(input, &1))
    |> length()
  end

  defp find_coords(grid, letter) do
    grid
    |> Enum.filter(fn {_coord, check} -> letter == check end)
    |> Enum.map(&elem(&1, 0))
  end

  defp find_xmas_words(grid, start) do
    # Words may spread out in any of the eight directions from the starting coord
    [{-1, 0}, {-1, 1}, {0, 1}, {1, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, -1}]
    |> Enum.filter(fn next ->
      matches?(start, next, 1, "M", grid) &&
        matches?(start, next, 2, "A", grid) &&
        matches?(start, next, 3, "S", grid)
    end)
  end

  defp find_x_mas_words(grid, start) do
    [[[{1, -1}, {1, 1}], [{-1, 1}, {-1, -1}]], [[{-1, -1}, {1, -1}], [{-1, 1}, {1, 1}]]]
    |> Enum.filter(fn [side1, side2] ->
      (Enum.all?(side1, &matches?(start, &1, 1, "M", grid)) &&
         Enum.all?(side2, &matches?(start, &1, 1, "S", grid))) ||
        (Enum.all?(side1, &matches?(start, &1, 1, "S", grid)) &&
           Enum.all?(side2, &matches?(start, &1, 1, "M", grid)))
    end)
  end

  def matches?({row1, col1}, {row2, col2}, offset, letter, grid) do
    Map.get(grid, {row1 + offset * row2, col1 + offset * col2}) == letter
  end

  def parse_input(input) do
    Advent.Grid.new(input)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

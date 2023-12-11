defmodule Y2023.Day11 do
  use Advent.Day, no: 11
  alias Advent.Grid

  def parts({_grid, units, empty}, offset \\ 2) do
    units
    |> Advent.permutations(2)
    |> Enum.map(&Enum.sort/1)
    |> Enum.uniq()
    |> Enum.map(fn [{from_row, from_col}, {to_row, to_col}] ->
      distance(from_row, to_row, empty.rows, offset) +
        distance(from_col, to_col, empty.cols, offset)
    end)
    |> Enum.sum()
  end

  defp distance(from, to, empty, offset) do
    abs(from - to) + Enum.count(from..to, &MapSet.member?(empty, &1)) * (offset - 1)
  end

  def parse_input(input) do
    grid = Grid.new(input)

    units =
      grid
      |> Enum.filter(fn {_coord, val} -> val == "#" end)
      |> Enum.map(&elem(&1, 0))

    {row, col} = Grid.size(grid)

    empty_rows =
      1..row
      |> Enum.filter(fn row ->
        Enum.all?(1..col, &empty?(grid, {row, &1}))
      end)
      |> MapSet.new()

    empty_cols =
      1..col
      |> Enum.filter(fn col ->
        Enum.all?(1..row, &empty?(grid, {&1, col}))
      end)
      |> MapSet.new()

    {grid, units, %{rows: empty_rows, cols: empty_cols}}
  end

  defp empty?(grid, coord), do: Map.fetch!(grid, coord) == "."

  def part1_verify, do: input() |> parse_input() |> parts(2)
  def part2_verify, do: input() |> parse_input() |> parts(1_000_000)
end

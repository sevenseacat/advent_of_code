defmodule Y2023.Day16 do
  use Advent.Day, no: 16

  alias Advent.Grid

  def part1(input) do
    run_beam(input, {1, 1, :right})
  end

  def part2(input) do
    input
    |> all_starting_positions()
    |> Enum.map(fn start -> run_beam(input, start) end)
    |> Enum.max()
  end

  def all_starting_positions(input) do
    {max_col, max_row} = Grid.size(input)

    (Enum.map(1..max_row, fn row -> [{row, 1, :right}, {row, max_col, :left}] end) ++
       Enum.map(1..max_col, fn col -> [{1, col, :down}, {max_row, col, :up}] end))
    |> List.flatten()
  end

  def run_beam(input, start) do
    do_run_beam(input, Grid.size(input), {[start], []}, MapSet.new())
  end

  defp do_run_beam(_grid, _max_coord, {[], []}, cache) do
    cache
    |> Enum.to_list()
    |> Enum.uniq_by(fn {row, col, _direction} -> {row, col} end)
    |> length
  end

  defp do_run_beam(grid, max_coord, {[], next}, cache) do
    do_run_beam(grid, max_coord, {next, []}, cache)
  end

  defp do_run_beam(
         grid,
         {max_row, max_col} = max_coord,
         {[{row, col, direction} = current | rest], next},
         cache
       ) do
    if MapSet.member?(cache, current) || row > max_row || row == 0 || col > max_col || col == 0 do
      do_run_beam(grid, max_coord, {rest, next}, cache)
    else
      next = calculate_next_positions(direction, {row, col}, Map.fetch!(grid, {row, col})) ++ next
      cache = MapSet.put(cache, current)
      do_run_beam(grid, max_coord, {rest, next}, cache)
    end
  end

  defp calculate_next_positions(:right, {row, col}, char) do
    case char do
      x when x in ["-", "."] -> [{row, col + 1, :right}]
      "|" -> [{row - 1, col, :up}, {row + 1, col, :down}]
      "\\" -> [{row + 1, col, :down}]
      "/" -> [{row - 1, col, :up}]
    end
  end

  defp calculate_next_positions(:left, {row, col}, char) do
    case char do
      x when x in ["-", "."] -> [{row, col - 1, :left}]
      "|" -> [{row - 1, col, :up}, {row + 1, col, :down}]
      "\\" -> [{row - 1, col, :up}]
      "/" -> [{row + 1, col, :down}]
    end
  end

  defp calculate_next_positions(:up, {row, col}, char) do
    case char do
      "-" -> [{row, col - 1, :left}, {row, col + 1, :right}]
      x when x in ["|", "."] -> [{row - 1, col, :up}]
      "\\" -> [{row, col - 1, :left}]
      "/" -> [{row, col + 1, :right}]
    end
  end

  defp calculate_next_positions(:down, {row, col}, char) do
    case char do
      "-" -> [{row, col - 1, :left}, {row, col + 1, :right}]
      x when x in ["|", "."] -> [{row + 1, col, :down}]
      "\\" -> [{row, col + 1, :right}]
      "/" -> [{row, col - 1, :left}]
    end
  end

  def parse_input(input) do
    Grid.new(input)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

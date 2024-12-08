defmodule Y2024.Day08 do
  use Advent.Day, no: 08

  alias Advent.Grid

  def part1(input), do: do_parts(input, 1)
  def part2(input), do: do_parts(input, :max)

  defp do_parts(%{grid: grid, size: size}, num) do
    grid
    |> Enum.group_by(fn {_coord, node} -> node end)
    |> Enum.flat_map(fn {_node, nodes} -> find_antinodes(nodes, size, num) end)
    |> Enum.uniq()
  end

  defp find_antinodes([{{row1, col1}, _node}, {{row2, col2}, _}], size, 1) do
    {row_diff, col_diff} = {row1 - row2, col1 - col2}

    [{row1 + row_diff, col1 + col_diff}, {row2 - row_diff, col2 - col_diff}]
    |> Enum.reject(&out_of_grid?(&1, size))
  end

  defp find_antinodes([{{row1, col1}, _node}, {{row2, col2}, _}], {max_row, max_col}, :max) do
    {row_diff, col_diff} = {row1 - row2, col1 - col2}

    other_way = for i <- 0..row1, do: {row1 + i * row_diff, col1 + i * col_diff}
    one_way = for i <- 0..(max_row - row2), do: {row2 - i * row_diff, col2 - i * col_diff}

    (one_way ++ other_way)
    |> Enum.reject(&out_of_grid?(&1, {max_row, max_col}))
  end

  defp find_antinodes(nodes, size, num) do
    nodes
    |> Advent.permutations(2)
    |> Enum.map(&Enum.sort/1)
    |> Enum.uniq()
    |> Enum.flat_map(&find_antinodes(&1, size, num))
  end

  defp out_of_grid?({row, col}, {max_row, max_col}) do
    row <= 0 || col <= 0 || row > max_row || col > max_col
  end

  def parse_input(input) do
    grid = Grid.new(input)
    size = Grid.size(grid)
    grid = Enum.filter(grid, fn {_coord, val} -> val != "." end) |> Map.new()

    %{grid: grid, size: size}
  end

  def part1_verify, do: input() |> parse_input() |> part1() |> length()
  def part2_verify, do: input() |> parse_input() |> part2() |> length()
end

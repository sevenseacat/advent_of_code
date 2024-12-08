defmodule Y2024.Day08 do
  use Advent.Day, no: 08

  alias Advent.Grid

  def part1(%{grid: grid, size: size}) do
    grid
    |> Enum.group_by(fn {_coord, node} -> node end)
    |> Enum.flat_map(fn {_node, nodes} -> find_antinodes(nodes, size) end)
    |> Enum.sort()
    |> Enum.uniq_by(fn {coord, _node} -> coord end)
  end

  # @doc """
  # iex> Day08.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp find_antinodes([{{row1, col1}, node}, {{row2, col2}, _}], {max_row, max_col}) do
    {row_diff, col_diff} = {row1 - row2, col1 - col2}

    [{{row1 + row_diff, col1 + col_diff}, node}, {{row2 - row_diff, col2 - col_diff}, node}]
    |> Enum.reject(fn {{row, col}, _node} ->
      row <= 0 || col <= 0 || row > max_row || col > max_col
    end)
  end

  defp find_antinodes(nodes, size) do
    nodes
    |> Advent.permutations(2)
    |> Enum.map(&Enum.sort/1)
    |> Enum.uniq()
    |> Enum.flat_map(&find_antinodes(&1, size))
  end

  def parse_input(input) do
    grid = Grid.new(input)
    size = Grid.size(grid)
    grid = Enum.filter(grid, fn {_coord, val} -> val != "." end) |> Map.new()

    %{grid: grid, size: size}
  end

  def part1_verify, do: input() |> parse_input() |> part1() |> length()
  # def part2_verify, do: input() |> parse_input() |> part2()
end

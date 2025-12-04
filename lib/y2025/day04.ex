defmodule Y2025.Day04 do
  use Advent.Day, no: 04
  alias Advent.Grid

  def part1(input) do
    find_removable_rolls(input)
    |> length
  end

  def part2(input, count \\ 0) do
    removable = find_removable_rolls(input)

    if removable == [] do
      count
    else
      removable
      |> Enum.reduce(input, fn {position, _}, acc -> Map.put(acc, position, ".") end)
      |> part2(count + length(removable))
    end
  end

  defp find_removable_rolls(input) do
    input
    |> Enum.filter(fn {position, item} ->
      item == "@" && length(adjacent_rolls(position, input)) < 4
    end)
  end

  defp adjacent_rolls({row, col}, input) do
    [
      {row - 1, col - 1},
      {row - 1, col},
      {row - 1, col + 1},
      {row, col - 1},
      {row, col + 1},
      {row + 1, col - 1},
      {row + 1, col},
      {row + 1, col + 1}
    ]
    |> Enum.filter(fn position -> Map.get(input, position) == "@" end)
  end

  def parse_input(input) do
    Grid.new(input)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

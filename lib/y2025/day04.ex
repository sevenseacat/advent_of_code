defmodule Y2025.Day04 do
  use Advent.Day, no: 04
  alias Advent.Grid

  def part1(input) do
    input
    |> MapSet.new()
    |> find_removable_rolls()
    |> length
  end

  def part2(input) do
    input
    |> MapSet.new()
    |> find_recursive_removable_rolls(input, 0)
  end

  defp find_recursive_removable_rolls(input, to_check, count) do
    removable_with_adjacent = find_removable_rolls(input, to_check)

    if removable_with_adjacent == [] do
      count
    else
      to_remove = Enum.map(removable_with_adjacent, &elem(&1, 0))

      # Only rolls that are adjacent to a removed roll are removable on the next pass
      unique_adjacents =
        (Enum.flat_map(removable_with_adjacent, &elem(&1, 1)) |> Enum.uniq()) -- to_remove

      input
      |> MapSet.difference(MapSet.new(to_remove))
      |> find_recursive_removable_rolls(unique_adjacents, count + length(to_remove))
    end
  end

  defp find_removable_rolls(input, to_check \\ nil) do
    to_check = to_check || input

    to_check
    |> Enum.map(fn position -> {position, adjacent_rolls(position, input)} end)
    |> Enum.filter(fn {_position, rolls} -> length(rolls) < 4 end)
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
    |> Enum.filter(fn position -> MapSet.member?(input, position) end)
  end

  def parse_input(input) do
    input
    |> Grid.new()
    |> Enum.filter(fn {_pos, item} -> item == "@" end)
    |> Enum.map(fn {pos, _item} -> pos end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

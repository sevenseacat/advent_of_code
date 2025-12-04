defmodule Y2025.Day04 do
  use Advent.Day, no: 04
  alias Advent.Grid

  def part1(input) do
    input
    |> Enum.filter(fn {position, item} ->
      item == "@" && length(adjacent_rolls(position, input)) < 4
    end)
  end

  # @doc """
  # iex> Day04.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

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

  def part1_verify, do: input() |> parse_input() |> part1() |> length()
  # def part2_verify, do: input() |> parse_input() |> part2()
end

defmodule Y2017.Day03 do
  use Advent.Day, no: 03

  alias Y2017.Day03.{Board, Coordinate}

  @initial_move {1, 0}
  @puzzle_input 277_678

  @doc """
  iex> Day03.part1(1)
  0

  iex> Day03.part1(12)
  3

  iex> Day03.part1(23)
  2

  iex> Day03.part1(1024)
  31
  """
  def part1(input) when is_integer(input) do
    input
    |> Board.build()
    |> calculate_distance
  end

  defp calculate_distance([]), do: 0
  defp calculate_distance([%Coordinate{x: x, y: y} | _]), do: abs(x) + abs(y)

  def part1_verify, do: part1(@puzzle_input)
end

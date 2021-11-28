defmodule Y2015.Day25 do
  use Advent.Day, no: 25

  @row 2981
  @col 3075

  @doc """
  iex> Day25.part1(3, 4)
  7981243

  iex> Day25.part1(6, 2)
  6796745
  """
  def part1(row \\ @row, col \\ @col) do
    number = position(row, col)
    next_number(20_151_125, 1, number)
  end

  defp next_number(current, index, max) when index == max, do: current

  defp next_number(current, index, max) do
    next_number(rem(current * 252_533, 33_554_393), index + 1, max)
  end

  @doc """
  iex> Day25.position(1, 1)
  1

  iex> Day25.position(3, 4)
  19

  iex> Day25.position(5, 2)
  17
  """
  def position(row, col) do
    # Seems to work! Kinda adapted from https://brilliant.org/wiki/sum-of-n-n2-or-n3/
    base_row = row + col - 2
    div(base_row * (base_row + 1), 2) + col
  end

  def part1_verify, do: part1()
end

defmodule Y2015.Day01 do
  use Advent.Day, no: 1

  @doc """
  iex> Day01.part1("(())")
  0

  iex> Day01.part1("(()(()(")
  3

  iex> Day01.part1("))(")
  -1

  iex> Day01.part1(")))")
  -3
  """
  def part1(string, floor \\ 0)
  def part1("", floor), do: floor
  def part1(<<"(", rest::binary>>, floor), do: part1(rest, floor + 1)
  def part1(<<")", rest::binary>>, floor), do: part1(rest, floor - 1)

  @doc """
  iex> Day01.part2(")")
  1

  iex> Day01.part2("()())")
  5
  """
  def part2(string, floor \\ 0, index \\ 0)
  def part2(_, floor, index) when floor < 0, do: index
  def part2(<<"(", rest::binary>>, floor, index), do: part2(rest, floor + 1, index + 1)
  def part2(<<")", rest::binary>>, floor, index), do: part2(rest, floor - 1, index + 1)

  def part1_verify do
    input() |> part1()
  end

  def part2_verify do
    input() |> part2()
  end
end

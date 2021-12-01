defmodule Y2021.Day01 do
  use Advent.Day, no: 1

  @doc """
  iex> Day01.part1([199, 200, 208, 210, 200, 207, 240, 269, 260, 263])
  7
  """
  def part1(list, count \\ 0)

  def part1([a, b | rest], count) do
    new_count = if a < b, do: count + 1, else: count
    part1([b | rest], new_count)
  end

  def part1(_, count), do: count

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
end

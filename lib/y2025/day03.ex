defmodule Y2025.Day03 do
  use Advent.Day, no: 03

  @doc """
  iex> Day03.part1([
  ...>   [9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1],
  ...>   [8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 9],
  ...>   [2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 7, 8],
  ...>   [8, 1, 8, 1, 8, 1, 9, 1, 1, 1, 1, 2, 1, 1, 1]
  ...> ])
  357
  """
  def part1(input) do
    input
    |> Enum.sum_by(&max_joltage(&1, 2))
  end

  @doc """
  iex> Day03.part2([
  ...>   [9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1],
  ...>   [8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 9],
  ...>   [2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 7, 8],
  ...>   [8, 1, 8, 1, 8, 1, 9, 1, 1, 1, 1, 2, 1, 1, 1]
  ...> ])
  3121910778619
  """
  def part2(input) do
    input
    |> Enum.sum_by(&max_joltage(&1, 12))
  end

  @doc """
  iex> Day03.max_joltage([9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1], 2)
  98

  iex> Day03.max_joltage([8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 9], 2)
  89

  iex> Day03.max_joltage([2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 7, 8], 2)
  78

  iex> Day03.max_joltage([8, 1, 8, 1, 8, 1, 9, 1, 1, 1, 1, 2, 1, 1, 1], 2)
  92
  """
  def max_joltage(row, num, progress \\ [])

  def max_joltage(_, 0, progress) do
    progress
    |> Enum.reverse()
    |> Integer.undigits()
  end

  def max_joltage(row, num, progress) do
    {search, rest} =
      if num == 1 do
        {row, []}
      else
        Enum.split(row, -num + 1)
      end

    largest = Enum.max(search)
    index = Enum.find_index(row, &(&1 == largest))
    {_pre, post} = Enum.split(search, index)

    max_joltage(tl(post) ++ rest, num - 1, [largest | progress])
  end

  @doc """
  iex> Day03.parse_input("987\\n654\\n321")
  [[9,8,7],[6,5,4],[3,2,1]]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> String.to_integer()
      |> Integer.digits()
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

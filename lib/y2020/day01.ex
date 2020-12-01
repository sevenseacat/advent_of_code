defmodule Y2020.Day01 do
  use Advent.Day, no: 1

  @doc """
  iex> Day01.part1([1721, 979, 366, 299, 675, 1456])
  {{1721, 299}, 514579}
  """
  def part1(input) do
    {a, b} = Enum.find_value(input, fn i -> two_adds_to_2020(i, input) end)
    {{a, b}, a * b}
  end

  @doc """
  iex> Day01.part2([1721, 979, 366, 299, 675, 1456])
  {{979, 366, 675}, 241861950}
  """
  def part2(input) do
    {a, b, c} = Enum.find_value(input, fn i -> three_adds_to_2020(i, input) end)
    {{a, b, c}, a * b * c}
  end

  defp two_adds_to_2020(i, list) do
    Enum.find_value(list, fn j -> if i + j == 2020, do: {i, j} end)
  end

  defp three_adds_to_2020([i, j], list) do
    Enum.find_value(list, fn k -> if(i + j + k == 2020, do: {i, j, k}) end)
  end

  defp three_adds_to_2020(i, list) do
    Enum.find_value(list, fn j -> three_adds_to_2020([i, j], list) end)
  end

  @doc """
  iex> Day01.parse_input("1721\\n979\\n366\\n299\\n675\\n1456")
  [1721, 979, 366, 299, 675, 1456]
  """
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input() |> part1() |> elem(1)
  def part2_verify, do: input() |> parse_input() |> part2() |> elem(1)
end

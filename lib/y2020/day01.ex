defmodule Y2020.Day01 do
  use Advent.Day, no: 1

  @doc """
  iex> Day01.part1([1721, 979, 366, 299, 675, 1456])
  {{1721, 299}, 514579}
  """
  def part1(input) do
    {a, b} = Enum.find_value(input, fn i -> adds_to_2020(i, input) end)
    {{a, b}, a * b}
  end

  defp adds_to_2020(i, list) do
    Enum.find_value(list, fn j -> if i + j == 2020, do: {i, j} end)
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
end

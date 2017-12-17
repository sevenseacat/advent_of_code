defmodule Y2017.Day14 do
  use Advent.Day, no: 14

  alias Y2017.Day10

  @puzzle_input "nbysizxe"

  @doc """
  Testing a 128x128 grid takes way too long - the example uses 8x8.

  iex> Day14.part1("flqrgnkx", 8)
  29
  """
  def part1(input \\ @puzzle_input, size) do
    (size - 1)..0
    |> Enum.to_list()
    |> Stream.map(&calculate_hash(input, &1))
    |> Stream.map(&count_bits(&1, div(size, 4)))
    |> Enum.sum()
  end

  @doc """
  iex> Day14.count_bits("a0c2017", 7)
  9
  """
  def count_bits(string, size) do
    string
    |> String.codepoints()
    |> Enum.take(size)
    |> Enum.map(&bits/1)
    |> Enum.sum()
  end

  defp bits(char) do
    case char do
      "0" -> 0
      "1" -> 1
      "2" -> 1
      "3" -> 2
      "4" -> 1
      "5" -> 2
      "6" -> 2
      "7" -> 3
      "8" -> 1
      "9" -> 2
      "a" -> 2
      "b" -> 3
      "c" -> 2
      "d" -> 3
      "e" -> 3
      "f" -> 4
    end
  end

  defp calculate_hash(input, suffix) do
    Day10.part2("#{input}-#{suffix}")
  end

  def part1_verify, do: part1(128)
end

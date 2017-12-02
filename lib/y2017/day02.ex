defmodule Y2017.Day02 do
  use Advent.Day, no: 02

  def part1(input) do
    input
    |> String.split("\n")
    |> Enum.map(&to_ints/1)
    |> Enum.map(&part_1_line_value/1)
    |> Enum.sum()
  end

  defp to_ints(line) do
    line
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  defp part_1_line_value(line) do
    Enum.max(line) - Enum.min(line)
  end

  def part1_verify, do: input() |> part1()
end

defmodule Y2022.Day01 do
  use Advent.Day, no: 01

  def part1(input) do
    input
    |> Enum.map(&Enum.sum/1)
    |> Enum.max()
  end

  def part2(input) do
    input
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end

  def parse_input(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_block/1)
  end

  defp parse_block(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

defmodule Y2024.Day01 do
  use Advent.Day, no: 01

  def part1(input) do
    input
    |> Enum.map(&Enum.sort/1)
    |> Enum.zip()
    |> Enum.map(fn {a, b} -> abs(a - b) end)
    |> Enum.sum()
  end

  def part2(input) do
    [left, right] = input
    right_frequencies = Enum.frequencies(right)

    Enum.reduce(left, 0, fn val, acc -> acc + val * Map.get(right_frequencies, val, 0) end)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> String.split("   ")
      |> Enum.map(&String.to_integer/1)
    end)
    |> Advent.transpose()
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

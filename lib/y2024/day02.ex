defmodule Y2024.Day02 do
  use Advent.Day, no: 02

  def part1(input) do
    Enum.count(input, &safe?/1)
  end

  def part2(input) do
    Enum.count(input, &safe_with_problem_dampener?/1)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      String.split(row, " ") |> Enum.map(&String.to_integer/1)
    end)
  end

  def safe?([a, a | _]), do: false

  def safe?([a, b | rest]) do
    multiplier = if b - a > 0, do: 1, else: -1
    check_safe?([a, b | rest], multiplier)
  end

  def safe_with_problem_dampener?(list) do
    dampened =
      0..length(list)
      |> Enum.map(&List.delete_at(list, &1))

    safe?(list) || Enum.any?(dampened, &safe?/1)
  end

  defp check_safe?([_], _), do: true

  defp check_safe?([a, b | rest], multiplier) do
    ((b - a) * multiplier) in 1..3 && check_safe?([b | rest], multiplier)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

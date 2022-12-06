defmodule Y2022.Day06 do
  use Advent.Day, no: 06

  def part1(input), do: do_parts(input, 4, 0)

  def part2(input), do: do_parts(input, 14, 0)

  defp do_parts(string, desired_length, count) do
    uniq_chars =
      string
      |> Enum.take(desired_length)
      |> Enum.uniq()

    if length(uniq_chars) == desired_length do
      count + desired_length
    else
      do_parts(tl(string), desired_length, count + 1)
    end
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.graphemes()
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

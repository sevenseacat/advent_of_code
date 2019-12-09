defmodule Y2019.Day09 do
  # This day just uses Day 5 (the intcode VM) with different input.

  use Advent.Day, no: 9

  alias Y2019.Day05

  def part1_verify, do: input() |> Day05.parse_input() |> Day05.part1(1) |> hd()
  def part2_verify, do: input() |> Day05.parse_input() |> Day05.part1(2) |> hd()
end

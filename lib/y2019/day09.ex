defmodule Y2019.Day09 do
  # This day just uses Day 5 (the intcode VM) with different input.

  use Advent.Day, no: 9

  alias Y2019.{Day05, Intcode}

  def part1_verify, do: input() |> Intcode.from_string() |> Day05.parts(1) |> hd()
  def part2_verify, do: input() |> Intcode.from_string() |> Day05.parts(2) |> hd()
end

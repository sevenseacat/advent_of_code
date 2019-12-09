defmodule Y2019.Day09 do
  use Advent.Day, no: 9

  alias Y2019.Day05

  def part1_verify, do: input() |> Day05.parse_input() |> Day05.part1(1) |> hd()
end

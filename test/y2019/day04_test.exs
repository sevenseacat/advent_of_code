defmodule Y2019.Day04Test do
  use ExUnit.Case, async: true
  alias Y2019.Day04
  doctest Day04

  test "verification, part 1", do: assert(Day04.part1_verify() == 1640)
  test "verification, part 2", do: assert(Day04.part2_verify() == 1126)
end

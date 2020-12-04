defmodule Y2020.Day04Test do
  use ExUnit.Case, async: true
  alias Y2020.Day04
  doctest Day04

  test "verification, part 1", do: assert(Day04.part1_verify() == 226)
  test "verification, part 2", do: assert(Day04.part2_verify() == 160)
end

defmodule Y2015.Day19Test do
  use ExUnit.Case, async: true
  alias Y2015.Day19
  doctest Day19

  test "verification, part 1", do: assert(Day19.part1_verify() == 509)
  test "verification, part 2", do: assert(Day19.part2_verify() == 195)
end

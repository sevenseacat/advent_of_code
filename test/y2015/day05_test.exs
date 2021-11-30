defmodule Y2015.Day05Test do
  use ExUnit.Case, async: true
  alias Y2015.Day05
  doctest Day05

  test "verification, part 1", do: assert(Day05.part1_verify() == 258)
  test "verification, part 2", do: assert(Day05.part2_verify() == 53)
end

defmodule Y2015.Day17Test do
  use ExUnit.Case, async: true
  alias Y2015.Day17
  doctest Day17

  test "verification, part 1", do: assert(Day17.part1_verify() == 654)
  test "verification, part 2", do: assert(Day17.part2_verify() == 57)
end

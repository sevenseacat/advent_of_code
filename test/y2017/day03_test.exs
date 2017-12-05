defmodule Y2017.Day03Test do
  use ExUnit.Case, async: true
  alias Y2017.Day03
  alias Y2017.Day03.Coordinate
  doctest Day03

  test "verification, part 1", do: assert(Day03.part1_verify() == 475)
  test "verification, part 2", do: assert(Day03.part2_verify() == 279_138)
end

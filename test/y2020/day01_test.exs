defmodule Y2020.Day01Test do
  use ExUnit.Case, async: true
  alias Y2020.Day01
  doctest Day01

  test "verification, part 1", do: assert(Day01.part1_verify() == 776_064)
  test "verification, part 2", do: assert(Day01.part2_verify() == 6_964_490)
end

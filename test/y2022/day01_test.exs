defmodule Y2022.Day01Test do
  use ExUnit.Case, async: true
  alias Y2022.Day01
  doctest Day01

  test "verification, part 1", do: assert(Day01.part1_verify() == 67027)
  test "verification, part 2", do: assert(Day01.part2_verify() == 197_291)
end

defmodule Y2021.Day01Test do
  use ExUnit.Case, async: true
  alias Y2021.Day01
  doctest Day01

  test "verification, part 1", do: assert(Day01.part1_verify() == 1448)
  test "verification, part 2", do: assert(Day01.part2_verify() == 1471)
end

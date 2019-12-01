defmodule Y2019.Day01Test do
  use ExUnit.Case, async: true
  alias Y2019.Day01
  doctest Day01

  test "verification, part 1", do: assert(Day01.part1_verify() == 3_299_598)
  test "verification, part 2", do: assert(Day01.part2_verify() == 4_946_546)
end

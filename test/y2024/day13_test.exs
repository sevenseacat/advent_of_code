defmodule Y2024.Day13Test do
  use ExUnit.Case, async: true
  alias Y2024.Day13
  doctest Day13

  test "verification, part 1", do: assert(Day13.part1_verify() == 27157)
  test "verification, part 2", do: assert(Day13.part2_verify() == 104_015_411_578_548)
end

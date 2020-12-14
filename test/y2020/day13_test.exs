defmodule Y2020.Day13Test do
  use ExUnit.Case, async: true
  alias Y2020.Day13
  doctest Day13

  test "verification, part 1", do: assert(Day13.part1_verify() == 3865)
  test "verification, part 2", do: assert(Day13.part2_verify() == 415_579_909_629_976)
end

defmodule Y2019.Day13Test do
  use ExUnit.Case, async: true
  alias Y2019.Day13
  doctest Day13

  test "verification, part 1", do: assert(Day13.part1_verify() == 315)
  test "verification, part 2", do: assert(Day13.part2_verify() == 16171)
end

defmodule Y2021.Day02Test do
  use ExUnit.Case, async: true
  alias Y2021.Day02
  doctest Day02

  test "verification, part 1", do: assert(Day02.part1_verify() == 1_728_414)
  test "verification, part 2", do: assert(Day02.part2_verify() == 1_765_720_035)
end

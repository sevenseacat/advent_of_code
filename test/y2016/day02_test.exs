defmodule Y2016.Day02Test do
  use ExUnit.Case, async: true
  alias Y2016.Day02
  doctest Day02

  test "verification, part 1", do: assert(Day02.part1_verify() == "56855")
  test "verification, part 2", do: assert(Day02.part2_verify() == "B3C27")
end

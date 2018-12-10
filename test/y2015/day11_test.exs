defmodule Y2015.Day11Test do
  use ExUnit.Case, async: true
  alias Y2015.Day11
  doctest Day11

  test "verification, part 1", do: assert(Day11.part1_verify() == "hxbxxyzz")

  test "verification, part 2", do: assert(Day11.part2_verify() == "hxcaabcc")
end

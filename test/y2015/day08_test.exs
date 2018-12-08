defmodule Y2015.Day08Test do
  use ExUnit.Case, async: true
  alias Y2015.Day08
  doctest Day08

  test "verification, part 1", do: assert(Day08.part1_verify() == 1333)
  test "verification, part 2", do: assert(Day08.part2_verify() == 2046)

  test "sample input" do
    assert Day08.part1("test/y2015/input/day08.txt") == 12
  end
end

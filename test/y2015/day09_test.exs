defmodule Y2015.Day09Test do
  use ExUnit.Case, async: true
  alias Y2015.Day09
  doctest Day09

  test "verification, part 1", do: assert(Day09.part1_verify() == 117)
  test "verification, part 2", do: assert(Day09.part2_verify() == 909)
end

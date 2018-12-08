defmodule Y2015.Day10Test do
  use ExUnit.Case, async: true
  alias Y2015.Day10
  doctest Day10

  test "verification, part 1", do: assert(Day10.part1_verify() == 252_594)

  test "verification, part 2", do: assert(Day10.part2_verify() == 3_579_328)
end

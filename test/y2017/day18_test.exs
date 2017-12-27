defmodule Y2017.Day18Test do
  use ExUnit.Case, async: true
  alias Y2017.{Day18, Day182}
  doctest Day18
  doctest Day182

  test "verification, part 1", do: assert(Day18.part1_verify() == 8600)
  test "verification, part 2", do: assert(Day182.part2_verify() == 7239)
end

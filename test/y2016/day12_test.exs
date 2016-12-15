defmodule Y2016.Day12Test do
  use ExUnit.Case, async: true
  alias Y2016.Day12
  doctest Day12

  test "verification, part 1", do: assert(Day12.part1_verify() == 318_009)
  test "verification, part 2", do: assert(Day12.part2_verify() == 9_227_663)
end

defmodule Y2016.Day17Test do
  use ExUnit.Case, async: true
  alias Y2016.Day17
  doctest Day17

  test "verification, part 1", do: assert(Day17.part1_verify() == "DRRDRLDURD")
  test "verification, part 2", do: assert(Day17.part2_verify() == 618)
end

defmodule Y2021.Day17Test do
  use ExUnit.Case, async: true
  alias Y2021.Day17
  doctest Day17

  test "verification, part 1", do: assert(Day17.part1_verify() == 6786)
  test "verification, part 2", do: assert(Day17.part2_verify() == 2313)
end

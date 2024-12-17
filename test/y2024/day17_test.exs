defmodule Y2024.Day17Test do
  use ExUnit.Case, async: true
  alias Y2024.Day17
  doctest Day17

  test "verification, part 1", do: assert(Day17.part1_verify() == "4,6,1,4,2,1,3,1,6")
  # test "verification, part 2", do: assert(Day17.part2_verify() == "update or delete me")
end

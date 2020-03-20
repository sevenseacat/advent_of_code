defmodule Y2019.Day15Test do
  use ExUnit.Case, async: true
  alias Y2019.Day15
  doctest Day15

  test "verification, part 1", do: assert(Day15.part1_verify() == 224)
  test "verification, part 2", do: assert(Day15.part2_verify() == 284)
end

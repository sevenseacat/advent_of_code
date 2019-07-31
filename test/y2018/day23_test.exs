defmodule Y2018.Day23Test do
  use ExUnit.Case, async: true
  alias Y2018.Day23
  doctest Day23

  test "verification, part 1", do: assert(Day23.part1_verify() == 619)
  test "verification, part 2", do: assert(Day23.part2_verify() == 71_631_000)
end

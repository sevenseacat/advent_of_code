defmodule Y2021.Day16Test do
  use ExUnit.Case, async: true
  alias Y2021.Day16
  doctest Day16

  test "verification, part 1", do: assert(Day16.part1_verify() == 891)
  test "verification, part 2", do: assert(Day16.part2_verify() == 673_042_777_597)
end

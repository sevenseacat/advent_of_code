defmodule Y2018.Day05Test do
  use ExUnit.Case, async: true
  alias Y2018.Day05
  doctest Day05

  test "verification, part 1", do: assert(Day05.part1_verify() == 11310)
  test "verification, part 2", do: assert(Day05.part2_verify() == 6020)
end

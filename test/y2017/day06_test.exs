defmodule Y2017.Day06Test do
  use ExUnit.Case, async: true
  alias Y2017.Day06
  doctest Day06

  test "verification, part 1", do: assert(Day06.part1_verify() == 5042)
  test "verification, part 2", do: assert(Day06.part2_verify() == 1086)
end

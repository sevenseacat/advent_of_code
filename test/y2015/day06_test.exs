defmodule Y2015.Day06Test do
  use ExUnit.Case, async: true
  alias Y2015.Day06
  doctest Day06

  test "verification, part 1", do: assert(Day06.part1_verify() == 400_410)
  test "verification, part 2", do: assert(Day06.part2_verify() == 15_343_601)
end

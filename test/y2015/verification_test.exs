defmodule Y2015.Test do
  use ExUnit.Case, async: true

  # Real solutions from the real problems with real input.
  describe "verification (2015)" do
    test "day 1, part 1", do: assert(Y2015.Day01.part1_verify() == 232)
    test "day 1, part 2", do: assert(Y2015.Day01.part2_verify() == 1783)
    test "day 2, part 1", do: assert(Y2015.Day02.part1_verify() == 1_586_300)
    test "day 2, part 2", do: assert(Y2015.Day02.part2_verify() == 3_737_498)
    test "day 3, part 1", do: assert(Y2015.Day03.part1_verify() == 2081)
    test "day 3, part 2", do: assert(Y2015.Day03.part2_verify() == 2341)
    test "day 4, part 1", do: assert(Y2015.Day04.part1_verify() == 282_749)
    test "day 4, part 2", do: assert(Y2015.Day04.part2_verify() == 9_962_624)
    test "day 5, part 1", do: assert(Y2015.Day05.part1_verify() == 258)
    test "day 5, part 2", do: assert(Y2015.Day05.part2_verify() == 53)
    test "day 6, part 1", do: assert(Y2015.Day06.part1_verify() == 400_410)
    test "day 6, part 2", do: assert(Y2015.Day06.part2_verify() == 15_343_601)
    test "day 7, part 1", do: assert(Y2015.Day07.part1_verify() == 46065)
    test "day 7, part 2", do: assert(Y2015.Day07.part2_verify() == 14134)
    test "day 8, part 1", do: assert(Y2015.Day08.part1_verify() == 1333)
  end
end

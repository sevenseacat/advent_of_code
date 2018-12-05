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
  end
end

defmodule Y2015.Test do
  use ExUnit.Case, async: true

  # Real solutions from the real problems with real input.
  describe "verification (2015)" do
    test "day 1, part 1", do: assert(Y2015.Day01.part1_verify() == 232)
    test "day 1, part 2", do: assert(Y2015.Day01.part2_verify() == 1783)
  end
end

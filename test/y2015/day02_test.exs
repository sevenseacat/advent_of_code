defmodule Y2015.Day02Test do
  use ExUnit.Case, async: true
  alias Y2015.Day02
  doctest Day02

  test "verification, part 1", do: assert(Day02.part1_verify() == 1_586_300)
  test "verification, part 2", do: assert(Day02.part2_verify() == 3_737_498)
end

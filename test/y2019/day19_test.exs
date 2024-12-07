defmodule Y2019.Day19Test do
  use ExUnit.Case, async: true
  alias Y2019.Day19
  doctest Day19

  test "verification, part 1", do: assert(Day19.part1_verify() == 179)
  test "verification, part 2", do: assert(Day19.part2_verify() == 9_760_485)
end

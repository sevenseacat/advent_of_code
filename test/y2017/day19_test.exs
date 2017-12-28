defmodule Y2017.Day19Test do
  use ExUnit.Case, async: true
  alias Y2017.Day19
  doctest Day19

  test "verification, part 1", do: assert(Day19.part1_verify() == "RYLONKEWB")
  test "verification, part 2", do: assert(Day19.part2_verify() == 16016)
end

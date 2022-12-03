defmodule Y2016.Day19Test do
  use ExUnit.Case, async: true
  alias Y2016.Day19
  doctest Day19

  test "verification, part 1", do: assert(Day19.part1_verify() == 1_842_613)

  # test "verification, part 2", do: assert(Day19.part2_verify() == 1_424_135)
end

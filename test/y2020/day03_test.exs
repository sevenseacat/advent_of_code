defmodule Y2020.Day03Test do
  use ExUnit.Case, async: true
  alias Y2020.Day03
  doctest Day03

  test "verification, part 1", do: assert(Day03.part1_verify() == 145)
  test "verification, part 2", do: assert(Day03.part2_verify() == 3_424_528_800)
end

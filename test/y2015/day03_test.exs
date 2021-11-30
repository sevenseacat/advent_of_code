defmodule Y2015.Day03Test do
  use ExUnit.Case, async: true
  alias Y2015.Day03
  doctest Day03

  test "verification, part 1", do: assert(Day03.part1_verify() == 2081)
  test "verification, part 2", do: assert(Day03.part2_verify() == 2341)
end

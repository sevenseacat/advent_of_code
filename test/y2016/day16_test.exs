defmodule Y2016.Day16Test do
  use ExUnit.Case, async: true
  alias Y2016.Day16
  doctest Day16

  test "verification, part 1", do: assert(Day16.part1_verify() == "10010110010011110")
  test "verification, part 2", do: assert(Day16.part2_verify() == "01101011101100011")
end

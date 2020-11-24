defmodule Y2015.Day16Test do
  use ExUnit.Case, async: true
  alias Y2015.Day16
  doctest Day16

  test "verification, part 1", do: assert(Day16.part1_verify() == "Sue 213")
  test "verification, part 2", do: assert(Day16.part2_verify() == "Sue 323")
end

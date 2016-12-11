defmodule Y2016.Day08Test do
  use ExUnit.Case, async: true
  alias Y2016.Day08
  doctest Day08

  # Part 2 was a visual puzzle, laying out the pixels and then reading them,
  # so no solution that can be programmatically checked
  test "verification, part 1", do: assert(Day08.part1_verify() == 119)
end

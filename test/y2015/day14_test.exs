defmodule Y2015.Day14Test do
  use ExUnit.Case, async: true
  alias Y2015.Day14
  doctest Day14

  test "verification, part 1", do: assert(Day14.part1_verify() == 2655)
end

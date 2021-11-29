defmodule Y2016.Day15Test do
  use ExUnit.Case, async: true
  alias Y2016.Day15
  doctest Day15

  test "verification, part 1", do: assert(Day15.part1_verify() == 16824)
end

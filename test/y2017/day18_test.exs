defmodule Y2017.Day18Test do
  use ExUnit.Case, async: true
  alias Y2017.Day18
  doctest Day18

  test "verification, part 1", do: assert(Day18.part1_verify() == 8600)
end

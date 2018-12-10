defmodule Y2015.Day12Test do
  use ExUnit.Case, async: true
  alias Y2015.Day12
  doctest Day12

  test "verification, part 1", do: assert(Day12.part1_verify() == 156_366)
end

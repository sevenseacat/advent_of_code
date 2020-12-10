defmodule Y2020.Day10Test do
  use ExUnit.Case, async: true
  alias Y2020.Day10
  doctest Day10

  test "verification, part 1", do: assert(Day10.part1_verify() == 1980)
  test "verification, part 2", do: assert(Day10.part2_verify() == 4_628_074_479_616)
end

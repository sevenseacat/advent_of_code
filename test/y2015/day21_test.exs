defmodule Y2015.Day21Test do
  use ExUnit.Case, async: true
  alias Y2015.Day21
  doctest Day21

  test "verification, part 1", do: assert(Day21.part1_verify() == 91)
  test "verification, part 2", do: assert(Day21.part2_verify() == 158)
end

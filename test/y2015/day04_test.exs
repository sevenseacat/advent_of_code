defmodule Y2015.Day04Test do
  use ExUnit.Case, async: true
  alias Y2015.Day04
  doctest Day04

  test "verification, part 1", do: assert(Day04.part1_verify() == 282_749)
  test "verification, part 2", do: assert(Day04.part2_verify() == 9_962_624)
end

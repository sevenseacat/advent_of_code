defmodule Y2018.Day01Test do
  use ExUnit.Case, async: true
  alias Y2018.Day01
  doctest Day01

  test "verification, part 1", do: assert(Day01.part1_verify() == 516)
end

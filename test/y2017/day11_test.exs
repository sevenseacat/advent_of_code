defmodule Y2017.Day11Test do
  use ExUnit.Case, async: true
  alias Y2017.Day11
  doctest Day11

  test "verification, part 1", do: assert(Day11.part1_verify() == 747)
end

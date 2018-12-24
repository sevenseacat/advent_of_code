defmodule Y2018.Day20Test do
  use ExUnit.Case, async: true
  alias Y2018.Day20
  doctest Day20

  test "verification, part 1", do: assert(Day20.part1_verify() == 3725)
  test "verification, part 2", do: assert(Day20.part2_verify() == 8541)
end

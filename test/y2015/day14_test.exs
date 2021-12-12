defmodule Y2015.Day14Test do
  use ExUnit.Case, async: true
  alias Y2015.Day14
  doctest Day14

  @tag timeout: :infinity
  test "verification, part 1", do: assert(Day14.part1_verify() == 2655)

  @tag timeout: :infinity
  test "verification, part 2", do: assert(Day14.part2_verify() == 1059)
end

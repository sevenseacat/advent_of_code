defmodule Y2020.Day07Test do
  use ExUnit.Case, async: true
  alias Y2020.Day07
  doctest Day07

  test "verification, part 1", do: assert(Day07.part1_verify() == 172)
  test "verification, part 2", do: assert(Day07.part2_verify() == 39645)
end

defmodule Y2024.Day11Test do
  use ExUnit.Case, async: false
  alias Y2024.Day11
  doctest Day11

  test "verification, part 1", do: assert(Day11.part1_verify() == 183_435)
  # test "verification, part 2", do: assert(Day11.part2_verify() == "update or delete me")
end

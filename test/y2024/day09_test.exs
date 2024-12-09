defmodule Y2024.Day09Test do
  use ExUnit.Case, async: true
  alias Y2024.Day09
  doctest Day09

  test "verification, part 1", do: assert(Day09.part1_verify() == 6_241_633_730_082)
  # test "verification, part 2", do: assert(Day09.part2_verify() == "update or delete me")
end

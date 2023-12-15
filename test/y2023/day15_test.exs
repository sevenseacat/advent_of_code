defmodule Y2023.Day15Test do
  use ExUnit.Case, async: true
  alias Y2023.Day15
  doctest Day15

  test "verification, part 1", do: assert(Day15.part1_verify() == 513_172)
  test "verification, part 2", do: assert(Day15.part2_verify() == 237_806)
end

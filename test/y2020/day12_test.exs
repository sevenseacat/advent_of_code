defmodule Y2020.Day12Test do
  use ExUnit.Case, async: true
  alias Y2020.Day12
  doctest Day12

  test "verification, part 1", do: assert(Day12.part1_verify() == 1533)
  test "verification, part 2", do: assert(Day12.part2_verify() == 25235)
end

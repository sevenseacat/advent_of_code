defmodule Y2024.Day03Test do
  use ExUnit.Case, async: true
  alias Y2024.Day03
  doctest Day03

  test "verification, part 1", do: assert(Day03.part1_verify() == 188_116_424)
  test "verification, part 2", do: assert(Day03.part2_verify() == 104_245_808)
end

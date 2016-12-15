defmodule Y2021.Day03Test do
  use ExUnit.Case, async: true
  alias Y2021.Day03
  doctest Day03

  test "verification, part 1", do: assert(Day03.part1_verify() == 3_687_446)
  test "verification, part 2", do: assert(Day03.part2_verify() == 4_406_844)
end
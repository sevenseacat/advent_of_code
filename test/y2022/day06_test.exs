defmodule Y2022.Day06Test do
  use ExUnit.Case, async: true
  alias Y2022.Day06
  doctest Day06

  test "verification, part 1", do: assert(Day06.part1_verify() == 1920)
  test "verification, part 2", do: assert(Day06.part2_verify() == 2334)
end

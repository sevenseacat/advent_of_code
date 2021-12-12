defmodule Y2016.Day14Test do
  use ExUnit.Case, async: true
  alias Y2016.Day14
  alias Y2016.Day14.Cache
  doctest Day14

  test "verification, part 1", do: assert(Day14.part1_verify() == 16106)

  @tag timeout: :infinity
  test "verification, part 2", do: assert(Day14.part2_verify() == 22423)
end

defmodule Y2017.Day05Test do
  use ExUnit.Case, async: true
  alias Y2017.Day05
  doctest Day05

  test "verification, part 1", do: assert(Day05.part1_verify() == 325_922)

  @tag timeout: :infinity
  test "verification, part 2", do: assert(Day05.part2_verify() == 24_490_906)
end

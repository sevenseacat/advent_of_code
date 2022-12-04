defmodule Y2022.Day04Test do
  use ExUnit.Case, async: true
  alias Y2022.Day04
  doctest Day04

  test "verification, part 1", do: assert(Day04.part1_verify() == 556)
  test "verification, part 2", do: assert(Day04.part2_verify() == 876)

  test "part1/1" do
    input =
      Day04.parse_input("""
      2-4,6-8
      2-3,4-5
      5-7,7-9
      2-8,3-7
      6-6,4-6
      2-6,4-8
      """)

    assert Day04.part1(input) == 2
  end

  test "part2/1" do
    input =
      Day04.parse_input("""
      2-4,6-8
      2-3,4-5
      5-7,7-9
      2-8,3-7
      6-6,4-6
      2-6,4-8
      """)

    assert Day04.part2(input) == 4
  end
end

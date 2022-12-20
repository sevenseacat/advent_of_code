defmodule Y2020.Day18Test do
  use ExUnit.Case, async: true
  alias Y2020.Day18
  doctest Day18

  test "verification, part 1", do: assert(Day18.part1_verify() == 510_009_915_468)
  # test "verification, part 2", do: assert(Day18.part2_verify() == "update or delete me")

  test "part1/1" do
    assert 71 == Day18.part1("1 + 2 * 3 + 4 * 5 + 6")
    assert 51 == Day18.part1("1 + (2 * 3) + (4 * (5 + 6))")
    assert 26 == Day18.part1("2 * 3 + (4 * 5)")
    assert 437 == Day18.part1("5 + (8 * 3 + 9 + 3 * 4 * 3)")
    assert 12240 == Day18.part1("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))")
    assert 13632 == Day18.part1("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2")
  end
end

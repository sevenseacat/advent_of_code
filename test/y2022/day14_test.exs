defmodule Y2022.Day14Test do
  use ExUnit.Case, async: true
  alias Y2022.Day14
  doctest Day14

  @sample "498,4 -> 498,6 -> 496,6\n503,4 -> 502,4 -> 502,9 -> 494,9\n"

  test "verification, part 1", do: assert(Day14.part1_verify() == 805)
  test "verification, part 2", do: assert(Day14.part2_verify() == 25161)

  test "part1/1" do
    assert 24 == Day14.parse_input(@sample) |> Day14.part1()
  end

  test "part2/1" do
    assert 93 == Day14.parse_input(@sample) |> Day14.part2()
  end

  test "parse_input/1" do
    assert Day14.parse_input(@sample) ==
             MapSet.new([
               {4, 498},
               {5, 498},
               {6, 498},
               {6, 497},
               {6, 496},
               {4, 503},
               {4, 502},
               {5, 502},
               {6, 502},
               {7, 502},
               {8, 502},
               {9, 502},
               {9, 501},
               {9, 500},
               {9, 499},
               {9, 498},
               {9, 497},
               {9, 496},
               {9, 495},
               {9, 494}
             ])
  end
end

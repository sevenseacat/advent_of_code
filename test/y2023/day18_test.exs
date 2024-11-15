defmodule Y2023.Day18Test do
  use ExUnit.Case, async: true
  alias Y2023.Day18
  doctest Day18

  test "verification, part 1", do: assert(Day18.part1_verify() == 68115)
  test "verification, part 2", do: assert(Day18.part2_verify() == 71_262_565_063_800)

  @sample_input """
  R 6 (#70c710)
  D 5 (#0dc571)
  L 2 (#5713f0)
  D 2 (#d2c081)
  R 2 (#59c680)
  D 2 (#411b91)
  L 5 (#8ceee2)
  U 2 (#caa173)
  L 1 (#1b58a2)
  U 2 (#caa171)
  R 2 (#7807d2)
  U 3 (#a77fa3)
  L 2 (#015232)
  U 2 (#7a21e3)
  """

  test "part 1" do
    input = Day18.parse_input(@sample_input)
    assert Day18.part1(input) == 62
  end

  test "part 2" do
    input = Day18.parse_input(@sample_input)
    assert Day18.part2(input) == 952_408_144_115
  end

  describe "shoelace algorithm" do
    test "example 1" do
      coords = [{2, 7}, {10, 1}, {8, 6}, {11, 7}, {7, 10}]
      assert 32 == Day18.run_shoelace_algorithm(coords)
    end
  end
end

defmodule Y2021.Day20Test do
  use ExUnit.Case, async: true
  alias Y2021.Day20
  doctest Day20

  test "verification, part 1", do: assert(Day20.part1_verify() == 4873)
  test "verification, part 2", do: assert(Day20.part2_verify() == 16394)

  test "parts/1" do
    input =
      Day20.parse_input("""
      ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

      #..#.
      #....
      ##..#
      ..#..
      ..###
      """)

    assert Day20.parts(input, 0) == 10
    assert Day20.parts(input, 1) == 24
    assert Day20.parts(input, 2) == 35
    assert Day20.parts(input, 50) == 3351
  end
end
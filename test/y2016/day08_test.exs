defmodule Y2016.Day08Test do
  use ExUnit.Case, async: true
  alias Y2016.Day08
  doctest Day08

  import ExUnit.CaptureIO

  test "verification, part 1", do: assert(Day08.part1_verify() == 119)

  test "verification, part 2" do
    assert capture_io(&Day08.part2_verify/0) == """
           ####.####.#..#.####..###.####..##...##..###...##..
           ...#.#....#..#.#....#....#....#..#.#..#.#..#.#..#.
           ..#..###..####.###..#....###..#..#.#....#..#.#..#.
           .#...#....#..#.#.....##..#....#..#.#.##.###..#..#.
           #....#....#..#.#.......#.#....#..#.#..#.#....#..#.
           ####.#....#..#.#....###..#.....##...###.#.....##..
           """
  end
end

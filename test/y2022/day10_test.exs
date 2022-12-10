defmodule Y2022.Day10Test do
  use ExUnit.Case, async: true
  alias Y2022.Day10
  doctest Day10

  import ExUnit.CaptureIO

  test "verification, part 1", do: assert(Day10.part1_verify() == 15020)

  test "verification, part 2" do
    output = """
    ####.####.#..#..##..#....###...##..###..
    #....#....#..#.#..#.#....#..#.#..#.#..#.
    ###..###..#..#.#....#....#..#.#..#.#..#.
    #....#....#..#.#.##.#....###..####.###..
    #....#....#..#.#..#.#....#....#..#.#....
    ####.#.....##...###.####.#....#..#.#....
    """

    assert output == capture_io(&Day10.part2_verify/0)
  end

  test "part1/1" do
    assert 13140 == Day10.parse_input(test_data()) |> Day10.part1()
  end

  test "part2/1" do
    output = """
    ##..##..##..##..##..##..##..##..##..##..
    ###...###...###...###...###...###...###.
    ####....####....####....####....####....
    #####.....#####.....#####.....#####.....
    ######......######......######......####
    #######.......#######.......#######.....
    """

    assert output == capture_io(fn -> Day10.parse_input(test_data()) |> Day10.part2() end)
  end

  def test_data(), do: File.read!("test/y2022/input/day10.txt")
end

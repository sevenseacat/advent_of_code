defmodule Y2023.Day11Test do
  use ExUnit.Case, async: true
  alias Y2023.Day11
  doctest Day11

  test "verification, part 1", do: assert(Day11.part1_verify() == 9_723_824)
  test "verification, part 2", do: assert(Day11.part2_verify() == 731_244_261_352)

  @sample_input """
  ...#......
  .......#..
  #.........
  ..........
  ......#...
  .#........
  .........#
  ..........
  .......#..
  #...#.....
  """

  test "both parts" do
    assert 374 == Day11.parse_input(@sample_input) |> Day11.parts()
    assert 1030 == Day11.parse_input(@sample_input) |> Day11.parts(10)
    assert 8410 == Day11.parse_input(@sample_input) |> Day11.parts(100)
  end
end

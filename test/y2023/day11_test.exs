defmodule Y2023.Day11Test do
  use ExUnit.Case, async: true
  alias Y2023.Day11
  doctest Day11

  test "verification, part 1", do: assert(Day11.part1_verify() == "update or delete me")
  # test "verification, part 2", do: assert(Day11.part2_verify() == "update or delete me")

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

  test "part 1" do
    assert 374 == Day11.parse_input(@sample_input) |> Day11.part1()
  end
end

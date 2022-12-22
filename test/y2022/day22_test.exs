defmodule Y2022.Day22Test do
  use ExUnit.Case, async: true
  alias Y2022.Day22
  doctest Day22

  test "verification, part 1", do: assert(Day22.part1_verify() == 50412)
  # test "verification, part 2", do: assert(Day22.part2_verify() == "update or delete me")

  @sample_input """
          ...#
          .#..
          #...
          ....
  ...#.......#
  ........#...
  ..#....#....
  ..........#.
          ...#....
          .....#..
          .#......
          ......#.

  10R5L5R10L4R5L5
  """

  test "part1/1" do
    assert 6032 == Day22.parse_input(@sample_input) |> Day22.part1()
  end
end

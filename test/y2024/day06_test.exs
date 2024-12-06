defmodule Y2024.Day06Test do
  use ExUnit.Case, async: true
  alias Y2024.Day06
  doctest Day06

  @input """
  ....#.....
  .........#
  ..........
  ..#.......
  .......#..
  ..........
  .#..^.....
  ........#.
  #.........
  ......#...
  """

  test "part 1" do
    assert Day06.parse_input(@input) |> Day06.part1() == 41
  end

  test "verification, part 1", do: assert(Day06.part1_verify() == 5095)
  # test "verification, part 2", do: assert(Day06.part2_verify() == "update or delete me")
end

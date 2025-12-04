defmodule Y2025.Day04Test do
  use ExUnit.Case, async: true
  alias Y2025.Day04
  doctest Day04

  test "verification, part 1", do: assert(Day04.part1_verify() == 1433)
  # test "verification, part 2", do: assert(Day04.part2_verify() == "update or delete me")

  @sample """
  ..@@.@@@@.
  @@@.@.@.@@
  @@@@@.@.@@
  @.@@@@..@.
  @@.@@@@.@@
  .@@@@@@@.@
  .@.@.@.@@@
  @.@@@.@@@@
  .@@@@@@@@.
  @.@.@@@.@.
  """

  test "part 1" do
    grid = Advent.Grid.new(@sample)
    assert length(Day04.part1(grid)) == 13
  end
end

defmodule Y2025.Day04Test do
  use ExUnit.Case, async: true
  alias Y2025.Day04
  doctest Day04

  test "verification, part 1", do: assert(Day04.part1_verify() == 1433)
  test "verification, part 2", do: assert(Day04.part2_verify() == 8616)

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
    actual = @sample |> Day04.parse_input() |> Day04.part1()
    assert actual == 13
  end

  test "part 2" do
    actual = @sample |> Day04.parse_input() |> Day04.part2()
    assert actual == 43
  end
end

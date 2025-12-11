defmodule Y2020.Day22Test do
  use ExUnit.Case, async: true
  alias Y2020.Day22
  doctest Day22

  test "verification, part 1", do: assert(Day22.part1_verify() == 35562)
  test "verification, part 2", do: assert(Day22.part2_verify() == 34424)

  @sample """
  Player 1:
  9
  2
  6
  3
  1

  Player 2:
  5
  8
  4
  7
  10
  """

  test "parse_input" do
    answer = Day22.parse_input(@sample)
    assert answer == {[9, 2, 6, 3, 1], [5, 8, 4, 7, 10]}
  end
end

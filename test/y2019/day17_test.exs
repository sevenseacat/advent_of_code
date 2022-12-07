defmodule Y2019.Day17Test do
  use ExUnit.Case, async: true
  alias Y2019.Day17
  doctest Day17

  test "verification, part 1", do: assert(Day17.part1_verify() == 5788)

  test "part1/1" do
    input = """
    ..#..........
    ..#..........
    #######...###
    #.#...#...#.#
    #############
    ..#...#...#..
    ..#####...^..
    """

    assert 76 == Day17.part1(input)
  end
end

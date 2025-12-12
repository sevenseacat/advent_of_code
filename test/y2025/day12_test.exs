defmodule Y2025.Day12Test do
  use ExUnit.Case, async: true
  alias Y2025.Day12
  doctest Day12

  test "verification, part 1", do: assert(Day12.part1_verify() == 472)

  @sample """
  0:
  ###
  ##.
  ##.

  1:
  ###
  ##.
  .##

  2:
  .##
  ###
  ##.

  3:
  ##.
  ###
  ##.

  4:
  ###
  #..
  ###

  5:
  ###
  .#.
  ###

  4x4: 0 0 0 0 2 0
  12x5: 1 0 1 0 2 2
  12x5: 1 0 1 0 3 2
  """

  test "parse_input" do
    {_presents, boxes} = Day12.parse_input(@sample)

    assert boxes ==
             [
               {4, 4, [0, 0, 0, 0, 2, 0]},
               {12, 5, [1, 0, 1, 0, 2, 2]},
               {12, 5, [1, 0, 1, 0, 3, 2]}
             ]
  end
end

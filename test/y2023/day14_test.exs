defmodule Y2023.Day14Test do
  use ExUnit.Case, async: true
  alias Y2023.Day14
  doctest Day14

  test "verification, part 1", do: assert(Day14.part1_verify() == 105_208)
  test "verification, part 2", do: assert(Day14.part2_verify() == 102_943)

  @sample_input """
  O....#....
  O.OO#....#
  .....##...
  OO.#O....O
  .O.....O#.
  O.#..O.#.#
  ..O..#O..O
  .......O..
  #....###..
  #OO..#....
  """

  test "part 1" do
    assert 136 == Day14.parse_input(@sample_input) |> Day14.part1()
  end

  test "part 2" do
    assert 64 == Day14.parse_input(@sample_input) |> Day14.part2()
  end
end

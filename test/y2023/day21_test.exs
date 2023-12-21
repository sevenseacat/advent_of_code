defmodule Y2023.Day21Test do
  use ExUnit.Case, async: true
  alias Y2023.Day21
  doctest Day21

  test "verification, part 1", do: assert(Day21.part1_verify() == 3733)
  # test "verification, part 2", do: assert(Day21.part2_verify() == "update or delete me")

  @sample_input """
  ...........
  .....###.#.
  .###.##..#.
  ..#.#...#..
  ....#.#....
  .##..S####.
  .##..#...#.
  .......##..
  .##.#.####.
  .##..##.##.
  ...........
  """

  test "part 1" do
    input = Day21.parse_input(@sample_input)

    assert Day21.part1(input, 1) == 2
    assert Day21.part1(input, 2) == 4
    assert Day21.part1(input, 3) == 6
    assert Day21.part1(input, 6) == 16
  end
end

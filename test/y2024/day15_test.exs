defmodule Y2024.Day15Test do
  use ExUnit.Case, async: true
  alias Y2024.Day15
  doctest Day15

  @sample """
  ########
  #..O.O.#
  ##@.O..#
  #...O..#
  #.#.O..#
  #...O..#
  #......#
  ########

  <^^>>>vv<v>>v<<
  """

  test "part1" do
    assert Day15.parse_input(@sample) |> Day15.part1() == 2028
  end

  test "run_movements" do
    {guard, rocks} = Day15.parse_input(@sample) |> Day15.run_movements()

    assert guard == {5, 5}
    assert Enum.sort(rocks) == [{2, 6}, {2, 7}, {4, 7}, {5, 4}, {6, 5}, {7, 5}]
  end

  test "verification, part 1", do: assert(Day15.part1_verify() == 1_568_399)
  # test "verification, part 2", do: assert(Day15.part2_verify() == "update or delete me")
end

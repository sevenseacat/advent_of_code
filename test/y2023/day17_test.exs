defmodule Y2023.Day17Test do
  use ExUnit.Case, async: true
  alias Y2023.Day17
  doctest Day17

  test "verification, part 1", do: assert(Day17.part1_verify() == 886)
  test "verification, part 2", do: assert(Day17.part2_verify() == 1055)

  @sample_input """
  2413432311323
  3215453535623
  3255245654254
  3446585845452
  4546657867536
  1438598798454
  4457876987766
  3637877979653
  4654967986887
  4564679986453
  1224686865563
  2546548887735
  4322674655533
  """

  test "part 1" do
    actual = Day17.parse_input(@sample_input) |> Day17.part1()
    assert 102 == actual
  end

  test "part 2, sample 1" do
    actual = Day17.parse_input(@sample_input) |> Day17.part2()
    assert 94 == actual
  end

  test "part 2, sample 2" do
    actual =
      """
      111111111111
      999999999991
      999999999991
      999999999991
      999999999991
      """
      |> Day17.parse_input()
      |> Day17.part2()

    assert 71 == actual
  end
end

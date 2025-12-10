defmodule Y2025.Day10Test do
  use ExUnit.Case, async: true
  alias Y2025.Day10
  doctest Day10

  test "verification, part 1", do: assert(Day10.part1_verify() == 438)
  test "verification, part 2", do: assert(Day10.part2_verify() == 16463)

  @sample """
  [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
  [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
  [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
  """

  test "parse_input" do
    answer = Day10.parse_input(@sample)

    assert Enum.at(answer, 1) == %{
             lights: %{0 => false, 1 => false, 2 => false, 3 => true, 4 => false},
             buttons: [[0, 2, 3, 4], [2, 3], [0, 4], [0, 1, 2], [1, 2, 3, 4]],
             joltage: %{0 => 7, 1 => 5, 2 => 12, 3 => 7, 4 => 2}
           }
  end

  test "part1" do
    answer = @sample |> Day10.parse_input() |> Day10.part1()
    assert answer == 7
  end

  test "part2" do
    answer = @sample |> Day10.parse_input() |> Day10.part2()
    assert answer == 33
  end

  test "find_min_presses (part 1)" do
    row = @sample |> Day10.parse_input() |> Enum.at(1)
    assert Day10.part1([row]) == 3
  end

  test "find_min_presses (part 2)" do
    rows = @sample |> Day10.parse_input()

    assert Day10.part2([Enum.at(rows, 0)]) == 10
    assert Day10.part2([Enum.at(rows, 1)]) == 12
    assert Day10.part2([Enum.at(rows, 2)]) == 11

    answer =
      "[#####.###.] (4,7,8) (0,1,2,3,5,6,8,9) (0,4,5,7,8,9) (2,3,5) (0,2,3,4,5,6,7,8) (5,6) (0,1,2,3,4,5,9) (0,1,2,5,6,9) (0,3,4,5,6,7,8,9) (3,4,5,6,8) (0,1,2,3,4,5,6,7,9) (0,8) (3,4,8,9) {261,225,243,252,56,278,262,29,257,242}"
      |> Day10.parse_input()
      |> Day10.part2()

    assert answer == 287
  end
end

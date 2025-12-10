defmodule Y2025.Day10Test do
  use ExUnit.Case, async: true
  alias Y2025.Day10
  doctest Day10

  test "verification, part 1", do: assert(Day10.part1_verify() == 438)
  # test "verification, part 2", do: assert(Day10.part2_verify() == "update or delete me")

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

  test "find_min_presses" do
    answer = @sample |> Day10.parse_input() |> Enum.at(1) |> Day10.find_min_presses()
    assert answer == 3
  end
end

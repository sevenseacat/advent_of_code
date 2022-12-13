defmodule Y2022.Day13Test do
  use ExUnit.Case, async: true
  alias Y2022.Day13
  doctest Day13

  @sample_input """
  [1,1,3,1,1]
  [1,1,5,1,1]

  [[1],[2,3,4]]
  [[1],4]

  [9]
  [[8,7,6]]

  [[4,4],4,4]
  [[4,4],4,4,4]

  [7,7,7,7]
  [7,7,7]

  []
  [3]

  [[[]]]
  [[]]

  [1,[2,[3,[4,[5,6,7]]]],8,9]
  [1,[2,[3,[4,[5,6,0]]]],8,9]
  """

  test "verification, part 1", do: assert(Day13.part1_verify() == 5013)
  test "verification, part 2", do: assert(Day13.part2_verify() == 25038)

  test "part1/1" do
    assert 13 == Day13.parse_input(@sample_input) |> Day13.part1()
  end

  test "part2/1" do
    assert 140 == Day13.parse_input(@sample_input) |> Day13.part2()
  end

  test "correct_order?/2" do
    assert Day13.correct_order?([1, 1, 3, 1, 1], [1, 1, 5, 1, 1])
    assert Day13.correct_order?([[1], [2, 3, 4]], [[1], 4])
    refute Day13.correct_order?([9], [[8, 7, 6]])
    assert Day13.correct_order?([[4, 4], 4, 4], [[4, 4], 4, 4, 4])
    refute Day13.correct_order?([7, 7, 7, 7], [7, 7, 7])
    assert Day13.correct_order?([], [3])
    refute Day13.correct_order?([[[]]], [[]])

    refute Day13.correct_order?(
             [1, [2, [3, [4, [5, 6, 7]]]], 8, 9],
             [1, [2, [3, [4, [5, 6, 0]]]], 8, 9]
           )
  end
end

defmodule Y2021.Day04Test do
  use ExUnit.Case, async: true
  alias Y2021.Day04
  doctest Day04

  test "verification, part 1", do: assert(Day04.part1_verify() == 49686)
  test "verification, part 2", do: assert(Day04.part2_verify() == 26878)

  describe "part1/2" do
    test "works for a full board" do
      board = [
        [{14, false}, {21, false}, {17, false}, {24, false}, {4, false}],
        [{10, false}, {16, false}, {15, false}, {9, false}, {19, false}],
        [{18, false}, {8, false}, {23, false}, {26, false}, {20, false}],
        [{22, false}, {11, false}, {13, false}, {6, false}, {5, false}],
        [{2, false}, {0, false}, {12, false}, {3, false}, {7, false}]
      ]

      numbers = "7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1"
      assert Day04.part1([board], numbers) == 4512
    end
  end

  describe "parse_input/1" do
    test "works for multiple boards" do
      input = """
      22 13 17 11  0
      8  2 23  4 24
      21  9 14 16  7
      6 10  3 18  5
      1 12 20 15 19

      1  2
      3  4
      """

      output = [
        [
          [{22, false}, {13, false}, {17, false}, {11, false}, {0, false}],
          [{8, false}, {2, false}, {23, false}, {4, false}, {24, false}],
          [{21, false}, {9, false}, {14, false}, {16, false}, {7, false}],
          [{6, false}, {10, false}, {3, false}, {18, false}, {5, false}],
          [{1, false}, {12, false}, {20, false}, {15, false}, {19, false}]
        ],
        [
          [{1, false}, {2, false}],
          [{3, false}, {4, false}]
        ]
      ]

      assert Day04.parse_input(input) == output
    end
  end
end

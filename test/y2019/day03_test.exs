defmodule Y2019.Day03Test do
  use ExUnit.Case, async: true
  alias Y2019.Day03
  doctest Day03

  test "verification, part 1", do: assert(Day03.part1_verify() == 399)
  test "verification, part 2", do: assert(Day03.part2_verify() == 15678)

  @sample_input_small [
    [{"R", 8}, {"U", 5}, {"L", 5}, {"D", 3}],
    [{"U", 7}, {"R", 6}, {"D", 4}, {"L", 4}]
  ]

  describe "parse_input/1" do
    test "it translates raw strings into lists of tuples" do
      assert Day03.parse_input("R8,U5,L5,D3\nU7,R6,D4,L4") == @sample_input_small
    end
  end

  describe "part1/1" do
    test "it works for small sample input" do
      assert Day03.part1(@sample_input_small) == 6
    end
  end

  describe "part2/1" do
    test "it works for small sample input" do
      assert Day03.part2(@sample_input_small) == 30
    end
  end
end

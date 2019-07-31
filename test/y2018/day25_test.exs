defmodule Y2018.Day25Test do
  use ExUnit.Case, async: true
  alias Y2018.Day25
  doctest Day25

  test "verification, part 1", do: assert(Day25.part1_verify() == 331)

  describe "part1" do
    test "sample input 1" do
      input = """
      -1,2,2,0
      0,0,2,-2
      0,0,0,-2
      -1,2,0,0
      -2,-2,-2,2
      3,0,2,-1
      -1,3,2,2
      -1,0,-1,0
      0,2,1,-2
      3,0,0,0
      """

      assert Day25.parse_input(input) |> Day25.part1() == 4
    end

    test "sample input 2" do
      input = """
      1,-1,0,1
      2,0,-1,0
      3,2,-1,0
      0,0,3,1
      0,0,-1,-1
      2,3,-2,0
      -2,2,0,0
      2,-2,0,-1
      1,-1,0,-1
      3,2,0,2
      """

      assert Day25.parse_input(input) |> Day25.part1() == 3
    end

    test "sample input 3" do
      input = """
      1,-1,-1,-2
      -2,-2,0,1
      0,2,1,3
      -2,3,-2,1
      0,2,3,-2
      -1,-1,1,-2
      0,-2,-1,0
      -2,2,3,-1
      1,2,2,0
      -1,-2,0,-2
      """

      assert Day25.parse_input(input) |> Day25.part1() == 8
    end

    test "sample input 4" do
      input = """
      0,0,0,0
      3,0,0,0
      0,3,0,0
      0,0,3,0
      0,0,0,3
      0,0,0,6
      9,0,0,0
      12,0,0,0
      """

      assert Day25.parse_input(input) |> Day25.part1() == 2
    end
  end
end

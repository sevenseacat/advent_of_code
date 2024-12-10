defmodule Y2024.Day10Test do
  use ExUnit.Case, async: true
  alias Y2024.Day10
  doctest Day10

  describe "part 1" do
    test "sample 1" do
      input = """
      ...0...
      ...1...
      ...2...
      6543456
      7.....7
      8.....8
      9.....9
      """

      assert Day10.parse_input(input) |> Day10.part1() == 2
    end

    test "sample 2" do
      input = """
      ..90..9
      ...1.98
      ...2..7
      6543456
      765.987
      876....
      987....
      """

      assert Day10.parse_input(input) |> Day10.part1() == 4
    end

    test "sample 3" do
      input = """
      10..9..
      2...8..
      3...7..
      4567654
      ...8..3
      ...9..2
      .....01
      """

      assert Day10.parse_input(input) |> Day10.part1() == 3
    end

    test "sample 4" do
      input = """
      89010123
      78121874
      87430965
      96549874
      45678903
      32019012
      01329801
      10456732
      """

      assert Day10.parse_input(input) |> Day10.part1() == 36
    end
  end

  test "verification, part 1", do: assert(Day10.part1_verify() == 638)
  test "verification, part 2", do: assert(Day10.part2_verify() == 1289)
end

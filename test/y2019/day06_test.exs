defmodule Y2019.Day06Test do
  use ExUnit.Case, async: true
  alias Y2019.Day06
  doctest Day06

  test "verification, part 1", do: assert(Day06.part1_verify() == 122_782)
  test "verification, part 2", do: assert(Day06.part2_verify() == 271)

  describe "part1/1" do
    test "sample input" do
      assert 42 == Day06.part1("COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L")
    end
  end

  describe "part2/1" do
    test "sample input" do
      actual =
        Day06.part2("COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L\nK)YOU\nI)SAN")

      assert 4 == actual
    end
  end
end

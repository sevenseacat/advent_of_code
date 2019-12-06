defmodule Y2019.Day06Test do
  use ExUnit.Case, async: true
  alias Y2019.Day06
  doctest Day06

  test "verification, part 1", do: assert(Day06.part1_verify() == 122_782)

  test "sample input for part 1" do
    assert 42 == Day06.part1("COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L")
  end
end

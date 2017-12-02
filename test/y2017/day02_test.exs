defmodule Y2017.Day02Test do
  use ExUnit.Case, async: true
  alias Y2017.Day02
  doctest Day02

  test "verification, part 1", do: assert(Day02.part1_verify() == 47623)
  test "verification, part 2", do: assert(Day02.part2_verify() == 312)

  test "example 1" do
    assert Day02.part1("5 1 9 5\n7 5 3\n2 4 6 8") == 18
  end

  test "example 2" do
    assert Day02.part2("5 9 2 8\n9 4 7 3\n3 8 6 5") == 9
  end
end

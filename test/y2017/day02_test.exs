defmodule Y2017.Day02Test do
  use ExUnit.Case, async: true
  alias Y2017.Day02
  doctest Day02

  test "verification, part 1", do: assert(Day02.part1_verify() == 47623)

  test "example 1" do
    assert Day02.part1("5 1 9 5\n7 5 3\n2 4 6 8") == 18
  end
end

defmodule Y2017.Day10Test do
  use ExUnit.Case, async: true
  alias Y2017.Day10
  doctest Day10

  test "verification, part 1", do: assert(Day10.part1_verify() == 9656)

  test "verification, part 2" do
    assert Day10.part2_verify() == "20b7b54c92bf73cf3e5631458a715149"
  end
end

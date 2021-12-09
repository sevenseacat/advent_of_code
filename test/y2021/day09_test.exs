defmodule Y2021.Day09Test do
  use ExUnit.Case, async: true
  alias Y2021.Day09
  doctest Day09

  @test_file "../../../test/y2021/input/day09"

  test "verification, part 1", do: assert(Day09.part1_verify() == 572)

  test "part1/1" do
    actual = Day09.input(@test_file) |> Day09.parse_input() |> Day09.part1()
    assert actual == 15
  end

  test "find_low_points/1" do
    actual = Day09.input(@test_file) |> Day09.parse_input() |> Day09.find_low_points()
    expected = [{{0, 1}, 1}, {{0, 9}, 0}, {{2, 2}, 5}, {{4, 6}, 5}]
    assert actual == expected
  end
end

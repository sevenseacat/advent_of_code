defmodule Y2021.Day10Test do
  use ExUnit.Case, async: true
  alias Y2021.Day10
  doctest Day10

  @test_file "../../../test/y2021/input/day10"

  test "verification, part 1", do: assert(Day10.part1_verify() == 389_589)

  test "part1/1" do
    actual = Day10.input(@test_file) |> Day10.parse_input() |> Day10.part1()
    assert actual == 26397
  end
end

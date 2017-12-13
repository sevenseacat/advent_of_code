defmodule Y2017.Day08Test do
  use ExUnit.Case, async: true
  alias Y2017.Day08
  doctest Day08

  @test_file "../../../test/y2017/input/day08"

  test "verification, part 1", do: assert(Day08.part1_verify() == 3880)
  test "verification, part 2", do: assert(Day08.part2_verify() == 5035)

  test "part 1" do
    assert Day08.input(@test_file) |> Day08.part1() == {"a", 1}
  end

  test "part 2" do
    assert Day08.input(@test_file) |> Day08.part2() == {"c", 10}
  end
end

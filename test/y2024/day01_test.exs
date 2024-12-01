defmodule Y2024.Day01Test do
  use ExUnit.Case, async: true
  alias Y2024.Day01
  doctest Day01

  @input """
  3   4
  4   3
  2   5
  1   3
  3   9
  3   3
  """

  test "part 1" do
    assert Day01.parse_input(@input) |> Day01.part1() == 11
  end

  test "part 2" do
    assert Day01.parse_input(@input) |> Day01.part2() == 31
  end

  test "verification, part 1", do: assert(Day01.part1_verify() == 3_508_942)
  test "verification, part 2", do: assert(Day01.part2_verify() == 26_593_248)
end

defmodule Y2020.Day17Test do
  use ExUnit.Case, async: true
  alias Y2020.Day17
  doctest Day17

  test "verification, part 1", do: assert(Day17.part1_verify() == 230)
  test "verification, part 2", do: assert(Day17.part2_verify() == 1600)

  @sample_input ".#.\n..#\n###"

  test "parts/2" do
    assert 112 == Day17.parse_input(@sample_input) |> Day17.parts(3)
    assert 848 == Day17.parse_input(@sample_input) |> Day17.parts(4)
  end
end

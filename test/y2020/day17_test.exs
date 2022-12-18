defmodule Y2020.Day17Test do
  use ExUnit.Case, async: true
  alias Y2020.Day17
  doctest Day17

  test "verification, part 1", do: assert(Day17.part1_verify() == 230)
  # test "verification, part 2", do: assert(Day17.part2_verify() == "update or delete me")

  @sample_input ".#.\n..#\n###"

  test "part1/1" do
    assert 112 == Day17.parse_input(@sample_input) |> Day17.part1()
  end
end

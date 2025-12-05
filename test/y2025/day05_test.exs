defmodule Y2025.Day05Test do
  use ExUnit.Case, async: true
  alias Y2025.Day05
  doctest Day05

  test "verification, part 1", do: assert(Day05.part1_verify() == 511)
  # test "verification, part 2", do: assert(Day05.part2_verify() == "update or delete me")

  @sample """
  3-5
  10-14
  16-20
  12-18

  1
  5
  8
  11
  17
  32
  """

  test "part 1" do
    actual = Day05.parse_input(@sample) |> Day05.part1()
    assert actual == 3
  end
end

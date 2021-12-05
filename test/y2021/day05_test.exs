defmodule Y2021.Day05Test do
  use ExUnit.Case, async: true
  alias Y2021.Day05
  doctest Day05

  test "verification, part 1", do: assert(Day05.part1_verify() == 6311)
  test "verification, part 2", do: assert(Day05.part2_verify() == 19929)

  @sample_input "0,9 -> 5,9
  8,0 -> 0,8
  9,4 -> 3,4
  2,2 -> 2,1
  7,0 -> 7,4
  6,4 -> 2,0
  0,9 -> 2,9
  3,4 -> 1,4
  0,0 -> 8,8
  5,5 -> 8,2"

  test "parses without diagonals" do
    output = Day05.parse_input(@sample_input) |> Day05.parts()
    assert output == 5
  end

  test "parses with diagonals" do
    output = Day05.parse_input(@sample_input, true) |> Day05.parts()
    assert output == 12
  end
end

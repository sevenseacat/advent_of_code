defmodule Y2024.Day04Test do
  use ExUnit.Case, async: true
  alias Y2024.Day04
  doctest Day04

  @input """
  MMMSXXMASM
  MSAMXMSMSA
  AMXSXMAAMM
  MSAMASMSMX
  XMASAMXAMM
  XXAMMXXAMA
  SMSMSASXSS
  SAXAMASAAA
  MAMMMXMMMM
  MXMXAXMASX
  """

  test "part 1" do
    assert Day04.parse_input(@input) |> Day04.part1() == 18
  end

  test "part 2" do
    assert Day04.parse_input(@input) |> Day04.part2() == 9
  end

  test "verification, part 1", do: assert(Day04.part1_verify() == 2462)
  test "verification, part 2", do: assert(Day04.part2_verify() == 1877)
end

defmodule Y2024.Day19Test do
  use ExUnit.Case, async: true
  alias Y2024.Day19
  doctest Day19

  @sample """
  r, wr, b, g, bwu, rb, gb, br

  brwrr
  bggr
  gbbr
  rrbgbr
  ubwu
  bwurrg
  brgr
  bbrgwb
  """

  test "part1" do
    assert Day19.parse_input(@sample) |> Day19.part1() == 6
  end

  test "parse_input" do
    assert %{from: from, to: to} = Day19.parse_input(@sample)
    assert [["r"], ["w", "r"] | _rest] = from
    assert [["b", "r", "w", "r", "r"], ["b", "g", "g", "r"] | _rest] = to
  end

  test "verification, part 1", do: assert(Day19.part1_verify() == 285)
  # test "verification, part 2", do: assert(Day19.part2_verify() == "update or delete me")
end

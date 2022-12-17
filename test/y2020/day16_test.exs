defmodule Y2020.Day16Test do
  use ExUnit.Case, async: true
  alias Y2020.Day16
  doctest Day16

  test "verification, part 1", do: assert(Day16.part1_verify() == 25984)
  # test "verification, part 2", do: assert(Day16.part2_verify() == "update or delete me")

  @sample_input """
  class: 1-3 or 5-7
  row: 6-11 or 33-44
  seat: 13-40 or 45-50

  your ticket:
  7,1,14

  nearby tickets:
  7,3,47
  40,4,50
  55,2,20
  38,6,12
  """

  test "part1/1" do
    assert 71 == Day16.parse_input(@sample_input) |> Day16.part1()
  end

  test "parse_input/1" do
    expected = %{
      fields: %{class: [{1, 3}, {5, 7}], row: [{6, 11}, {33, 44}], seat: [{13, 40}, {45, 50}]},
      me: [7, 1, 14],
      nearby: [[7, 3, 47], [40, 4, 50], [55, 2, 20], [38, 6, 12]]
    }

    assert expected == Day16.parse_input(@sample_input)
  end
end

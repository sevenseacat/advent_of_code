defmodule Y2020.Day16Test do
  use ExUnit.Case, async: true
  alias Y2020.Day16
  doctest Day16

  test "verification, part 1", do: assert(Day16.part1_verify() == 25984)
  test "verification, part 2", do: assert(Day16.part2_verify() == 1_265_347_500_049)

  @sample_input """
  class thing: 1-3 or 5-7
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

  @part2_input """
  class: 0-1 or 4-19
  row: 0-5 or 8-19
  seat: 0-13 or 16-19

  your ticket:
  11,12,13

  nearby tickets:
  3,9,18
  15,1,5
  5,14,9
  """

  test "part1/1" do
    assert 71 == Day16.parse_input(@sample_input) |> Day16.part1()
  end

  test "part2/2" do
    assert 12 == Day16.parse_input(@part2_input) |> Day16.part2("class")
  end

  test "determine_fields/1" do
    expected = Enum.sort([{"row", 0}, {"class", 1}, {"seat", 2}])

    assert expected == Day16.parse_input(@part2_input) |> Day16.determine_fields() |> Enum.sort()
  end

  test "parse_input/1" do
    expected = %{
      fields: [
        {"class thing", [{1, 3}, {5, 7}]},
        {"row", [{6, 11}, {33, 44}]},
        {"seat", [{13, 40}, {45, 50}]}
      ],
      me: [7, 1, 14],
      nearby: [[7, 3, 47], [40, 4, 50], [55, 2, 20], [38, 6, 12]]
    }

    assert expected == Day16.parse_input(@sample_input)
  end
end

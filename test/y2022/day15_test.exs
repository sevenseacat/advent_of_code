defmodule Y2022.Day15Test do
  use ExUnit.Case, async: true
  alias Y2022.Day15
  doctest Day15

  test "verification, part 1", do: assert(Day15.part1_verify() == 4_961_647)

  test "verification, part 2", do: assert(Day15.part2_verify() == 12_274_327_017_867)

  @sample_input """
  Sensor at x=2, y=18: closest beacon is at x=-2, y=15
  Sensor at x=9, y=16: closest beacon is at x=10, y=16
  Sensor at x=13, y=2: closest beacon is at x=15, y=3
  Sensor at x=12, y=14: closest beacon is at x=10, y=16
  Sensor at x=10, y=20: closest beacon is at x=10, y=16
  Sensor at x=14, y=17: closest beacon is at x=10, y=16
  Sensor at x=8, y=7: closest beacon is at x=2, y=10
  Sensor at x=2, y=0: closest beacon is at x=2, y=10
  Sensor at x=0, y=11: closest beacon is at x=2, y=10
  Sensor at x=20, y=14: closest beacon is at x=25, y=17
  Sensor at x=17, y=20: closest beacon is at x=21, y=22
  Sensor at x=16, y=7: closest beacon is at x=15, y=3
  Sensor at x=14, y=3: closest beacon is at x=15, y=3
  Sensor at x=20, y=1: closest beacon is at x=15, y=3
  """

  test "part1/1" do
    assert 26 == Day15.parse_input(@sample_input) |> Day15.part1(10)
  end

  test "part2/1" do
    assert {{11, 14}, 56_000_011} == Day15.parse_input(@sample_input) |> Day15.part2(20)
  end

  test "parse_input/1" do
    input = """
    Sensor at x=2, y=18: closest beacon is at x=-2, y=15
    Sensor at x=9, y=16: closest beacon is at x=10, y=16
    """

    output = [
      %{sensor: {18, 2}, beacon: {15, -2}, distance: 7},
      %{sensor: {16, 9}, beacon: {16, 10}, distance: 1}
    ]

    assert output == Day15.parse_input(input)
  end
end

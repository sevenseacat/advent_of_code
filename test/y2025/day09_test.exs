defmodule Y2025.Day09Test do
  use ExUnit.Case, async: true
  alias Y2025.Day09
  doctest Day09

  test "verification, part 1", do: assert(Day09.part1_verify() == 4_756_718_172)
  test "verification, part 2", do: assert(Day09.part2_verify() == 1_665_679_194)

  @sample """
  7,1
  11,1
  11,7
  9,7
  9,5
  2,5
  2,3
  7,3
  """

  test "part 1" do
    answer = @sample |> Day09.parse_input() |> Day09.part1()
    assert answer == 50
  end

  test "build_edges" do
    answer = @sample |> Day09.parse_input() |> Day09.build_edges() |> Enum.sort()

    assert answer ==
             Enum.sort([
               [{2, 3}, {2, 5}],
               [{7, 1}, {7, 3}],
               [{9, 5}, {9, 7}],
               [{11, 1}, {11, 7}],
               [{7, 1}, {11, 1}],
               [{2, 3}, {7, 3}],
               [{2, 5}, {9, 5}],
               [{9, 7}, {11, 7}]
             ])
  end

  test "part 2" do
    answer = @sample |> Day09.parse_input() |> Day09.part2()
    assert answer == 24
  end
end

defmodule Y2022.Day18Test do
  use ExUnit.Case, async: true
  alias Y2022.Day18
  doctest Day18

  test "verification, part 1", do: assert(Day18.part1_verify() == 3432)
  # test "verification, part 2", do: assert(Day18.part2_verify() == "update or delete me")

  @sample_input """
  2,2,2
  1,2,2
  3,2,2
  2,1,2
  2,3,2
  2,2,1
  2,2,3
  2,2,4
  2,2,6
  1,2,5
  3,2,5
  2,1,5
  2,3,5
  """

  test "part1/1" do
    assert 10 == Day18.parse_input("1,1,1\n2,1,1") |> Day18.part1()
    assert 64 == Day18.parse_input(@sample_input) |> Day18.part1()
  end
end

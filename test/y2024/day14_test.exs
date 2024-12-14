defmodule Y2024.Day14Test do
  use ExUnit.Case, async: true
  alias Y2024.Day14
  doctest Day14

  @sample """
  p=0,4 v=3,-3
  p=6,3 v=-1,-3
  p=10,3 v=-1,2
  p=2,0 v=2,-1
  p=0,0 v=1,3
  p=3,0 v=-2,-2
  p=7,6 v=-1,-3
  p=3,0 v=-1,-2
  p=9,3 v=2,3
  p=7,3 v=-1,2
  p=2,4 v=2,-3
  p=9,5 v=-3,-3
  """

  test "part1/1" do
    size = {11, 7}
    assert Day14.parse_input(@sample) |> Day14.part1(size, 100) == 12
  end

  test "verification, part 1", do: assert(Day14.part1_verify() == 226_236_192)
  test "verification, part 2", do: assert(Day14.part2_verify() == 8168)
end

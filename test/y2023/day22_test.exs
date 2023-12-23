defmodule Y2023.Day22Test do
  use ExUnit.Case, async: true
  alias Y2023.Day22
  doctest Day22

  test "verification, part 1", do: assert(Day22.part1_verify() == 507)
  # test "verification, part 2", do: assert(Day22.part2_verify() == "update or delete me")

  @sample_input """
  1,0,1~1,2,1
  0,0,2~2,0,2
  0,2,3~2,2,3
  0,0,4~0,2,4
  2,0,5~2,2,5
  0,1,6~2,1,6
  1,1,8~1,1,9
  """

  test "part 1" do
    assert Day22.parse_input(@sample_input) |> Day22.part1() == 5
  end
end

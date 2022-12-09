defmodule Y2022.Day09Test do
  use ExUnit.Case, async: true
  alias Y2022.Day09
  doctest Day09

  test "verification, part 1", do: assert(Day09.part1_verify() == 6266)
  # test "verification, part 2", do: assert(Day09.part2_verify() == "update or delete me")

  test "part1/1" do
    input = """
    R 4
    U 4
    L 3
    D 1
    R 4
    D 1
    L 5
    R 2
    """

    assert 13 == Day09.parse_input(input) |> Day09.part1()
  end
end

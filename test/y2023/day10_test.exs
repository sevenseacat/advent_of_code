defmodule Y2023.Day10Test do
  use ExUnit.Case, async: true
  alias Y2023.Day10
  doctest Day10

  test "verification, part 1", do: assert(Day10.part1_verify() == 7030)
  # test "verification, part 2", do: assert(Day10.part2_verify() == "update or delete me")

  test "part 1" do
    sample_1 = """
    -L|F7
    7S-7|
    L|7||
    -L-J|
    L|-JF
    """

    assert 4 == Day10.parse_input(sample_1) |> Day10.part1()

    sample_2 = """
    7-F7-
    .FJ|7
    SJLL7
    |F--J
    LJ.LJ
    """

    assert 8 == Day10.parse_input(sample_2) |> Day10.part1()
  end
end

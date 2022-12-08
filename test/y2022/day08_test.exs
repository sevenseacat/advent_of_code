defmodule Y2022.Day08Test do
  use ExUnit.Case, async: true
  alias Y2022.Day08
  doctest Day08

  test "verification, part 1", do: assert(Day08.part1_verify() == 1849)
  # test "verification, part 2", do: assert(Day08.part2_verify() == "update or delete me")

  test "part1/1" do
    input = """
    30373
    25512
    65332
    33549
    35390
    """

    assert 21 == Day08.parse_input(input) |> Day08.part1()
  end
end

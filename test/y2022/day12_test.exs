defmodule Y2022.Day12Test do
  use ExUnit.Case, async: true
  alias Y2022.Day12
  doctest Day12

  test "verification, part 1", do: assert(Day12.part1_verify() == 517)
  # test "verification, part 2", do: assert(Day12.part2_verify() == "update or delete me")

  test "part1/1" do
    input = """
    Sabqponm
    abcryxxl
    accszExk
    acctuvwj
    abdefghi
    """

    assert 31 == Day12.parse_input(input) |> Day12.part1()
  end
end

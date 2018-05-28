defmodule Y2017.Day24Test do
  use ExUnit.Case, async: true
  alias Y2017.Day24
  doctest Day24

  test "verification, part 1", do: assert(Day24.part1_verify() == 1868)

  test "generates all possible bridges given example input" do
    pipes = [{0, 2}, {2, 2}, {2, 3}, {3, 4}, {3, 5}, {0, 1}, {10, 1}, {9, 10}]

    bridges = [
      [],
      [{0, 1}],
      [{0, 1}, {10, 1}],
      [{0, 1}, {10, 1}, {9, 10}],
      [{0, 2}],
      [{0, 2}, {2, 3}],
      [{0, 2}, {2, 3}, {3, 4}],
      [{0, 2}, {2, 3}, {3, 5}],
      [{0, 2}, {2, 2}],
      [{0, 2}, {2, 2}, {2, 3}],
      [{0, 2}, {2, 2}, {2, 3}, {3, 4}],
      [{0, 2}, {2, 2}, {2, 3}, {3, 5}]
    ]

    assert Enum.sort(Day24.build_bridges([], 0, pipes)) == Enum.sort(bridges)
  end
end

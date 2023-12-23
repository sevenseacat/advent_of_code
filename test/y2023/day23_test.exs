defmodule Y2023.Day23Test do
  use ExUnit.Case, async: true
  alias Y2023.Day23
  doctest Day23

  test "verification, part 1", do: assert(Day23.part1_verify() == 2186)
  # test "verification, part 2", do: assert(Day23.part2_verify() == "update or delete me")

  @sample_input """
  #.#####################
  #.......#########...###
  #######.#########.#.###
  ###.....#.>.>.###.#.###
  ###v#####.#v#.###.#.###
  ###.>...#.#.#.....#...#
  ###v###.#.#.#########.#
  ###...#.#.#.......#...#
  #####.#.#.#######.#.###
  #.....#.#.#.......#...#
  #.#####.#.#.#########v#
  #.#...#...#...###...>.#
  #.#.#v#######v###.###v#
  #...#.>.#...>.>.#.###.#
  #####v#.#.###v#.#.###.#
  #.....#...#...#.#.#...#
  #.#########.###.#.#.###
  #...###...#...#...#.###
  ###.###.#.###v#####v###
  #...#...#.#.>.>.#.>.###
  #.###.###.#.###.#.#v###
  #.....###...###...#...#
  #####################.#
  """

  test "part 1" do
    assert Day23.parse_input(@sample_input) |> Day23.part1() == 94
  end

  test "part 2" do
    assert Day23.parse_input(@sample_input) |> Day23.part2() == 154
  end
end

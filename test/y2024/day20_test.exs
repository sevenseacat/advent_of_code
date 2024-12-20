defmodule Y2024.Day20Test do
  use ExUnit.Case, async: true
  alias Y2024.Day20
  doctest Day20

  @sample """
  ###############
  #...#...#.....#
  #.#.#.#.#.###.#
  #S#...#.#.#...#
  #######.#.#.###
  #######.#.#...#
  #######.#.###.#
  ###..E#...#...#
  ###.#######.###
  #...###...#...#
  #.#####.#.###.#
  #.#...#.#.#...#
  #.#.#.#.#.#.###
  #...#...#...###
  ###############
  """

  test "cheats" do
    expected = %{
      2 => 14,
      4 => 14,
      6 => 2,
      8 => 4,
      10 => 2,
      12 => 3,
      20 => 1,
      36 => 1,
      38 => 1,
      40 => 1,
      64 => 1
    }

    assert Day20.parse_input(@sample) |> Day20.cheats() == expected
  end

  test "verification, part 1", do: assert(Day20.part1_verify() == 1289)
  # test "verification, part 2", do: assert(Day20.part2_verify() == "update or delete me")
end

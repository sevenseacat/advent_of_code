defmodule Y2022.Day19Test do
  use ExUnit.Case, async: true
  alias Y2022.Day19
  doctest Day19

  test "verification, part 1", do: assert(Day19.part1_verify() == "update or delete me")
  # test "verification, part 2", do: assert(Day19.part2_verify() == "update or delete me")

  @sample_input """
  Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
  Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
  """

  test "part1/1" do
    assert 33 == Day19.parse_input(@sample_input) |> Day19.part1()
  end

  test "run_geode_checker/1" do
    blueprint = %{
      id: 1,
      costs: [
        {:geode, %{ore: 2, obsidian: 7}},
        {:obsidian, %{ore: 3, clay: 14}},
        {:clay, %{ore: 2}},
        {:ore, %{ore: 4}}
      ]
    }

    assert 9 == Day19.run_geode_cracker(blueprint)
  end
end

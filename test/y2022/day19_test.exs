defmodule Y2022.Day19Test do
  use ExUnit.Case, async: true
  alias Y2022.Day19
  doctest Day19

  test "verification, part 1", do: assert(Day19.part1_verify() == 1306)
  test "verification, part 2", do: assert(Day19.part2_verify() == 37604)

  @sample_input """
  Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
  Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
  """

  test "part1/1" do
    assert 33 == Day19.parse_input(@sample_input) |> Day19.part1()
  end

  test "part2/1" do
    assert 3472 == Day19.parse_input(@sample_input) |> Day19.part2()
  end

  describe "run_geode_checker/1" do
    test "sample blueprint" do
      blueprint = %{
        id: 1,
        costs: [
          {:geode, %{ore: 2, obsidian: 7}},
          {:obsidian, %{ore: 3, clay: 14}},
          {:clay, %{ore: 2}},
          {:ore, %{ore: 4}}
        ]
      }

      assert 9 == Day19.run_geode_cracker(blueprint, 24)
    end

    test "sample blueprint 2" do
      blueprint = %{
        id: 1,
        costs: [
          {:geode, %{ore: 3, obsidian: 12}},
          {:obsidian, %{ore: 3, clay: 8}},
          {:clay, %{ore: 3}},
          {:ore, %{ore: 2}}
        ]
      }

      assert 12 == Day19.run_geode_cracker(blueprint, 24)
    end

    test "blueprint 7" do
      # "Blueprint 7: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 10 clay. Each geode robot costs 2 ore and 7 obsidian."
      blueprint = %{
        id: 7,
        costs: [
          {:geode, %{ore: 2, obsidian: 7}},
          {:obsidian, %{ore: 4, clay: 10}},
          {:clay, %{ore: 4}},
          {:ore, %{ore: 4}}
        ]
      }

      # Using |> Enum.take(2) instead of 3 gives 3, instead of 4.
      assert 4 == Day19.run_geode_cracker(blueprint, 24)
    end
  end
end

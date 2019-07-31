defmodule Y2018.Day24Test do
  use ExUnit.Case, async: true
  alias Y2018.Day24
  doctest Day24
  import Day24, only: [find: 2]

  test "verification, part 1", do: assert(Day24.part1_verify() == 25088)
  test "verification, part 2", do: assert(Day24.part2_verify() == 2002)

  @armies [
    %{
      id: {1, :immune},
      units: 17,
      hp: 5390,
      immune: [],
      weak: [:radiation, :bludgeoning],
      attack: {4507, :fire},
      initiative: 2,
      targeting: nil
    },
    %{
      id: {2, :immune},
      units: 989,
      hp: 1274,
      immune: [:fire],
      weak: [:bludgeoning, :slashing],
      attack: {25, :slashing},
      initiative: 3,
      targeting: nil
    },
    %{
      id: {1, :infection},
      units: 801,
      hp: 4706,
      immune: [],
      weak: [:radiation],
      strong: [],
      attack: {116, :bludgeoning},
      initiative: 1,
      targeting: nil
    },
    %{
      id: {2, :infection},
      units: 4485,
      hp: 2961,
      immune: [:radiation],
      weak: [:fire, :cold],
      attack: {12, :slashing},
      initiative: 4,
      targeting: nil
    }
  ]

  describe "basic battle" do
    test "selecting targets" do
      armies = Day24.select_targets(@armies)

      assert find(armies, {1, :immune}).targeting == {2, :infection}
      assert find(armies, {2, :immune}).targeting == {1, :infection}
      assert find(armies, {1, :infection}).targeting == {1, :immune}
      assert find(armies, {2, :infection}).targeting == {2, :immune}
    end

    test "attacking" do
      armies = Day24.select_targets(@armies) |> Day24.attack()

      assert find(armies, {1, :immune}) == nil
      assert find(armies, {2, :immune}).units == 905
      assert find(armies, {1, :infection}).units == 797
      assert find(armies, {2, :infection}).units == 4434

      armies = Day24.select_targets(armies) |> Day24.attack()

      assert find(armies, {1, :immune}) == nil
      assert find(armies, {2, :immune}).units == 761
      assert find(armies, {1, :infection}).units == 793
      assert find(armies, {2, :infection}).units == 4434
    end
  end

  describe "part1" do
    test "can run through to the end" do
      assert {:infection, 5216} == Day24.part1(@armies)
    end
  end

  describe "boost" do
    test "can run through to the end" do
      assert {:immune, 51} == Day24.part1_with_boost(@armies, 1570)
    end
  end
end

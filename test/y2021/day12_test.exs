defmodule Y2021.Day12Test do
  use ExUnit.Case, async: true
  alias Y2021.Day12
  doctest Day12

  test "verification, part 1", do: assert(Day12.part1_verify() == 5958)
  test "verification, part 2", do: assert(Day12.part2_verify() == 150_426)

  describe "build_paths/1" do
    test "small input 1" do
      actual =
        Day12.build_paths([
          {"start", "A"},
          {"start", "b"},
          {"A", "c"},
          {"A", "b"},
          {"b", "d"},
          {"A", "end"},
          {"b", "end"}
        ])

      expected = [
        ["start", "A", "b", "A", "c", "A", "end"],
        ["start", "A", "b", "A", "end"],
        ["start", "A", "b", "end"],
        ["start", "A", "c", "A", "b", "A", "end"],
        ["start", "A", "c", "A", "b", "end"],
        ["start", "A", "c", "A", "end"],
        ["start", "A", "end"],
        ["start", "b", "A", "c", "A", "end"],
        ["start", "b", "A", "end"],
        ["start", "b", "end"]
      ]

      assert Enum.sort(actual) == expected
    end
  end
end

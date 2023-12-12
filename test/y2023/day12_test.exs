defmodule Y2023.Day12Test do
  use ExUnit.Case, async: true
  alias Y2023.Day12
  doctest Day12

  test "verification, part 1", do: assert(Day12.part1_verify() == 7090)
  # test "verification, part 2", do: assert(Day12.part2_verify() == "update or delete me")

  describe "possibilities" do
    def run_test(input) do
      input
      |> Day12.parse_input()
      |> hd()
      |> Day12.possibilities()
      |> Enum.sort()
    end

    test "line 1 - known" do
      actual = run_test("#.#.### 1,1,3")
      expected = ["#.#.###"]
      assert actual == expected
    end

    test "line 1 - unknown" do
      actual = run_test(".??..??...?##. 1,1,3")

      expected =
        Enum.sort([".#...#....###.", "..#...#...###.", ".#....#...###.", "..#..#....###."])

      assert actual == expected
    end

    test "line 2" do
      actual = run_test("???.### 1,1,3")
      expected = ["#.#.###"]
      assert actual == expected
    end
  end
end

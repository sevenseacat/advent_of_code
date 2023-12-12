defmodule Y2023.Day12Test do
  use ExUnit.Case, async: true
  alias Y2023.Day12
  doctest Day12

  test "verification, part 1", do: assert(Day12.part1_verify() == 7090)
  # test "verification, part 2", do: assert(Day12.part2_verify() == "update or delete me")

  describe "part1" do
    def run_part1(input) do
      input
      |> Day12.parse_input()
      |> Day12.part1()
    end

    test "line 1" do
      assert run_part1("???.### 1,1,3") == 1
    end

    test "line 2" do
      assert run_part1(".??..??...?##. 1,1,3") == 4
    end

    test "line 3" do
      assert run_part1("?#?#?#?#?#?#?#? 1,3,1,6") == 1
    end

    test "line 4" do
      assert run_part1("????.#...#... 4,1,1") == 1
    end

    test "line 5" do
      assert run_part1("????.######..#####. 1,6,5") == 4
    end

    test "line 6" do
      assert run_part1("?###???????? 3,2,1") == 10
    end
  end

  test "part2" do
    actual =
      ".??..??...?##. 1,1,3"
      |> Day12.parse_input()
      |> Day12.part2()

    assert 16384 == actual
  end
end

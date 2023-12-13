defmodule Y2023.Day12Test do
  use ExUnit.Case, async: true
  alias Y2023.Day12
  doctest Day12

  test "verification, part 1", do: assert(Day12.part1_verify() == 7090)
  test "verification, part 2", do: assert(Day12.part2_verify() == 6_792_010_726_878)

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

    test "error from real input" do
      assert run_part1(".??#?.#???#? 1,1,1,1") == 2
    end
  end

  describe "part2" do
    def run_part2(input) do
      input
      |> Day12.parse_input()
      |> Day12.part2()
    end

    test "line 1" do
      assert 1 == run_part2("???.### 1,1,3")
    end

    test "line 2" do
      assert 16384 == run_part2(".??..??...?##. 1,1,3")
    end

    test "line 3" do
      assert 1 == run_part2("?#?#?#?#?#?#?#? 1,3,1,6")
    end

    test "line 4" do
      assert 16 == run_part2("????.#...#... 4,1,1")
    end

    test "line 5" do
      assert 2500 == run_part2("????.######..#####. 1,6,5")
    end

    test "line 6" do
      assert 506_250 == run_part2("?###???????? 3,2,1")
    end

    test "the evil input" do
      assert 3_268_760 == run_part2("?????????? 1,1,4")
    end
  end
end

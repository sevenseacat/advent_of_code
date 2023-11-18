defmodule Y2020.Day19Test do
  use ExUnit.Case, async: true
  alias Y2020.Day19
  doctest Day19

  test "verification, part 1", do: assert(Day19.part1_verify() == 115)
  # test "verification, part 2", do: assert(Day19.part2_verify() == "update or delete me")

  @sample_input """
  0: 4 1 5
  1: 2 3 | 3 2
  2: 4 4 | 5 5
  3: 4 5 | 5 4
  4: "a"
  5: "b"

  ababbb
  bababa
  abbbab
  aaabbb
  aaaabbb
  """

  @sample_rules %{
    0 => [[4, 1, 5]],
    1 => [[2, 3], [3, 2]],
    2 => [[4, 4], [5, 5]],
    3 => [[4, 5], [5, 4]],
    4 => [["a"]],
    5 => [["b"]]
  }

  test "part1/1" do
    assert 2 == Day19.parse_input(@sample_input) |> Day19.part1()
  end

  describe "depth_first_search_for_match?/3" do
    def matches?(string, rules) do
      Day19.depth_first_search_for_match([{[0], String.graphemes(string)}], rules)
    end

    test "direct match rules" do
      rules = %{0 => [["a"]]}
      assert matches?("a", rules)
      refute matches?("aa", rules)
      refute matches?("b", rules)
      refute matches?("ba", rules)
    end

    test "one step rules" do
      rules = %{0 => [[1, 2]], 1 => [["a"]], 2 => [["b"]]}
      assert matches?("ab", rules)
      refute matches?("abb", rules)
      refute matches?("ba", rules)
    end

    test "one step option rules" do
      rules = %{
        0 => [[1, 2], [3, 4]],
        1 => [["a"]],
        2 => [["b"]],
        3 => [["c"]],
        4 => [["d"]]
      }

      assert matches?("ab", rules)
      refute matches?("abb", rules)
      refute matches?("bab", rules)
      assert matches?("cd", rules)
      refute matches?("cdd", rules)
      refute matches?("dcd", rules)
    end

    test "actual examples from problem statement" do
      assert matches?("ababbb", @sample_rules)
      assert matches?("abbbab", @sample_rules)
      refute matches?("bababa", @sample_rules)
      refute matches?("aaabbb", @sample_rules)
      refute matches?("aaaabbb", @sample_rules)
    end
  end

  test "parse_input/1" do
    expected = %{
      rules: @sample_rules,
      messages: ["ababbb", "bababa", "abbbab", "aaabbb", "aaaabbb"]
    }

    assert expected == Day19.parse_input(@sample_input)
  end
end

defmodule Y2024.Day05Test do
  use ExUnit.Case, async: true
  alias Y2024.Day05
  doctest Day05

  @input """
  47|53
  97|13
  97|61
  97|47
  75|29
  61|13
  75|53
  29|13
  97|29
  53|29
  61|53
  97|53
  61|29
  47|13
  75|47
  97|75
  47|61
  75|61
  47|29
  75|13
  53|13

  75,47,61,53,29
  97,61,53,29,13
  75,29,13
  75,97,47,61,53
  61,13,29
  97,13,75,29,47
  """

  test "parse_input" do
    {deps, manuals} = Day05.parse_input(@input)
    assert hd(deps) == {47, 53}
    assert hd(manuals) == [75, 47, 61, 53, 29]
  end

  test "in_order?" do
    {deps, _} = Day05.parse_input(@input)

    assert Day05.in_order?([75, 47, 61, 53, 29], deps)
    assert Day05.in_order?([97, 61, 53, 29, 13], deps)
    assert Day05.in_order?([75, 29, 13], deps)
    refute Day05.in_order?([75, 97, 47, 61, 53], deps)
    refute Day05.in_order?([61, 13, 29], deps)
    refute Day05.in_order?([97, 13, 75, 29, 47], deps)
  end

  describe "fix_order" do
    test "sample input" do
      {deps, _} = Day05.parse_input(@input)

      assert Day05.fix_order([75, 97, 47, 61, 53], deps) == [97, 75, 47, 61, 53]
      assert Day05.fix_order([61, 13, 29], deps) == [61, 29, 13]
      assert Day05.fix_order([97, 13, 75, 29, 47], deps) == [97, 75, 47, 29, 13]
    end

    test "real input" do
      {deps, _} = Day05.input() |> Day05.parse_input()

      input = [27, 26, 19, 69, 94, 34, 99, 87, 25]
      output = [99, 25, 27, 87, 19, 34, 26, 94, 69]

      assert Day05.fix_order(input, deps) == output
    end
  end

  test "part 1" do
    assert Day05.parse_input(@input) |> Day05.part1() == 143
  end

  test "verification, part 1", do: assert(Day05.part1_verify() == 5275)
  test "verification, part 2", do: assert(Day05.part2_verify() == 6191)
end

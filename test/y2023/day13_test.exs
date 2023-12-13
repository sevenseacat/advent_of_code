defmodule Y2023.Day13Test do
  use ExUnit.Case, async: true
  alias Y2023.Day13
  doctest Day13

  test "verification, part 1", do: assert(Day13.part1_verify() == 30518)
  test "verification, part 2", do: assert(Day13.part2_verify() == 36735)

  @sample_input """
  #.##..##.
  ..#.##.#.
  ##......#
  ##......#
  ..#.##.#.
  ..##..##.
  #.#.##.#.

  #...##..#
  #....#..#
  ..##..###
  #####.##.
  #####.##.
  ..##..###
  #....#..#
  """

  test "part 1" do
    assert 405 == Day13.parse_input(@sample_input) |> Day13.part1()
  end

  test "part 2" do
    assert 400 == Day13.parse_input(@sample_input) |> Day13.part2()
  end

  describe "reflection" do
    test "sample 1" do
      actual = Day13.parse_input(@sample_input) |> hd() |> Day13.reflection()
      assert {:vertical, 5} == actual
    end

    test "sample 2" do
      actual = Day13.parse_input(@sample_input) |> Enum.at(1) |> Day13.reflection()
      assert {:horizontal, 4} == actual
    end

    test "real input that failed" do
      input = """
      ###...##...##
      ...#..#####.#
      ###.##.#.....
      ..#...#...###
      ..##.###.....
      ....#...#...#
      #####...##.##
      ....#.##.####
      ....#.##.##.#
      """

      assert {:vertical, 1} == Day13.parse_input(input) |> hd() |> Day13.reflection()
    end
  end

  describe "smudged_reflection" do
    test "sample 1" do
      actual = Day13.parse_input(@sample_input) |> hd() |> Day13.smudged_reflection()
      assert {:horizontal, 3} == actual
    end

    test "sample 2" do
      actual = Day13.parse_input(@sample_input) |> Enum.at(1) |> Day13.smudged_reflection()
      assert {:horizontal, 1} == actual
    end

    test "real input that failed - grid 5" do
      input = """
      ....#....##....
      .##..##.####.##
      #..#.#...##...#
      .##.####....###
      #..#.##.####.##
      #..###.#.##.#.#
      .##.##.##..####
      """

      actual = Day13.parse_input(input) |> hd() |> Day13.smudged_reflection()
      assert {:vertical, 10} == actual
    end
  end
end

defmodule Y2021.Day09Test do
  use ExUnit.Case, async: true
  alias Y2021.Day09
  doctest Day09

  @test_file "../../../test/y2021/input/day09"

  test "verification, part 1", do: assert(Day09.part1_verify() == 572)
  test "verification, part 2", do: assert(Day09.part2_verify() == 847_044)

  setup do
    [input: Day09.input(@test_file) |> Day09.parse_input()]
  end

  test "part1/1", %{input: sample_input} do
    assert Day09.part1(sample_input) == 15
  end

  test "part2/1", %{input: sample_input} do
    assert Day09.part2(sample_input) == 1134
  end

  test "find_low_points/1", %{input: sample_input} do
    actual = Day09.find_low_points(sample_input)
    expected = [{{0, 1}, 1}, {{0, 9}, 0}, {{2, 2}, 5}, {{4, 6}, 5}]
    assert actual == expected
  end

  describe "find_basin/2" do
    test "first basin", %{input: sample_input} do
      actual = Day09.find_basin({{0, 1}, 1}, sample_input) |> Enum.sort()
      expected = [{{0, 0}, 2}, {{0, 1}, 1}, {{1, 0}, 3}]
      assert actual == expected
    end

    test "second basin", %{input: sample_input} do
      actual = Day09.find_basin({{0, 9}, 0}, sample_input) |> Enum.sort()

      expected =
        [
          {{0, 9}, 0},
          {{0, 5}, 4},
          {{0, 6}, 3},
          {{0, 7}, 2},
          {{0, 8}, 1},
          {{1, 6}, 4},
          {{1, 8}, 2},
          {{1, 9}, 1},
          {{2, 9}, 2}
        ]
        |> Enum.sort()

      assert actual == expected
    end
  end
end

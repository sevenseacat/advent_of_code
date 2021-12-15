defmodule Y2021.Day15Test do
  use ExUnit.Case, async: true
  alias Y2021.Day15
  doctest Day15

  @test_file "../../../test/y2021/input/day15"

  test "verification, part 1", do: assert(Day15.part1_verify() == 583)

  # Currently fails due to a bug in libgraph - see https://github.com/bitwalker/libgraph/issues/44
  @tag :skip
  test "verification, part 2", do: assert(Day15.part2_verify() == 2927)

  setup do
    [input: Day15.input(@test_file) |> Day15.parse_input()]
  end

  test "part1/1", %{input: input} do
    assert Day15.part1(input) == 40
  end

  test "part2/1", %{input: input} do
    assert Day15.part2(input) == 315
  end

  test "grow_input/3" do
    input = "12\n39"
    actual = Day15.parse_input(input) |> Day15.grow_input({1, 1}, {2, 2})

    expected = %{
      {0, 0} => 1,
      {0, 1} => 2,
      {1, 0} => 3,
      {1, 1} => 9,
      {0, 2} => 2,
      {0, 3} => 3,
      {1, 2} => 4,
      {1, 3} => 1,
      {2, 0} => 2,
      {2, 1} => 3,
      {3, 0} => 4,
      {3, 1} => 1,
      {2, 2} => 3,
      {2, 3} => 4,
      {3, 2} => 5,
      {3, 3} => 2
    }

    assert actual == expected
  end
end

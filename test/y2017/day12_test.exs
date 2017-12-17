defmodule Y2017.Day12Test do
  use ExUnit.Case, async: true
  alias Y2017.Day12
  doctest Day12

  test "verification, part 1", do: assert(Day12.part1_verify() == 128)
  test "verification, part 2", do: assert(Day12.part2_verify() == 209)

  test "input parsing" do
    output = Day12.input("../../../test/y2017/input/day12") |> Day12.parse_input()

    assert output == %{
             0 => [2],
             1 => [1],
             2 => [0, 3, 4],
             3 => [2, 4],
             4 => [2, 3, 6],
             5 => [6],
             6 => [4, 5]
           }
  end

  test "part 1" do
    assert Day12.part1(
             %{
               0 => [2],
               1 => [1],
               2 => [0, 3, 4],
               3 => [2, 4],
               4 => [2, 3, 6],
               5 => [6],
               6 => [4, 5]
             },
             0
           ) ==
             [0, 2, 3, 4, 5, 6]
  end

  test "part 2" do
    assert Day12.part2(%{
             0 => [2],
             1 => [1],
             2 => [0, 3, 4],
             3 => [2, 4],
             4 => [2, 3, 6],
             5 => [6],
             6 => [4, 5]
           }) ==
             [[0, 2, 3, 4, 5, 6], [1]]
  end
end

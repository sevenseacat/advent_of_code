defmodule Y2024.Day08Test do
  use ExUnit.Case, async: true
  alias Y2024.Day08
  doctest Day08

  @input """
  ............
  ........0...
  .....0......
  .......0....
  ....0.......
  ......A.....
  ............
  ............
  ........A...
  .........A..
  ............
  ............
  """

  test "part 1" do
    actual = Day08.parse_input(@input) |> Day08.part1() |> Enum.sort()

    assert [
             {1, 7},
             {1, 12},
             {2, 4},
             {3, 5},
             {3, 11},
             {4, 3},
             {5, 10},
             {6, 2},
             {6, 7},
             {7, 4},
             {8, 1},
             {8, 8},
             {11, 11},
             {12, 11}
           ] = actual
  end

  test "part 2" do
    assert Day08.parse_input(@input) |> Day08.part2() |> length() == 34
  end

  test "verification, part 1", do: assert(Day08.part1_verify() == 220)
  test "verification, part 2", do: assert(Day08.part2_verify() == 813)
end

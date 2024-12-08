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
    actual = Day08.parse_input(@input) |> Day08.part1()

    assert [
             {{1, 7}, _},
             {{1, 12}, _},
             {{2, 4}, _},
             {{3, 5}, _},
             {{3, 11}, _},
             {{4, 3}, _},
             {{5, 10}, _},
             {{6, 2}, _},
             {{6, 7}, _},
             {{7, 4}, _},
             {{8, 1}, _},
             {{8, 8}, _},
             {{11, 11}, _},
             {{12, 11}, _}
           ] = actual
  end

  test "verification, part 1", do: assert(Day08.part1_verify() == 220)
  # test "verification, part 2", do: assert(Day08.part2_verify() == "update or delete me")
end

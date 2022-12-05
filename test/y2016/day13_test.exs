defmodule Y2016.Day13Test do
  use ExUnit.Case, async: true
  alias Y2016.Day13
  alias Y2016.Day13.Position
  doctest Day13
  doctest Day13.Position

  test "verification, part 1", do: assert(Day13.part1_verify() == 82)
  test "verification, part 2", do: assert(Day13.part2_verify() == 138)

  test "running an actual scenario for a given initial position and returning a path length" do
    path = Position.initial() |> Day13.get_optimal_path([7, 4], 10)

    assert path == [
             [1, 2],
             [2, 2],
             [3, 2],
             [3, 3],
             [3, 4],
             [4, 4],
             [4, 5],
             [5, 5],
             [6, 5],
             [6, 4],
             [7, 4]
           ]
  end
end

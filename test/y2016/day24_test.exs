defmodule Y2016.Day24Test do
  use ExUnit.Case, async: true
  alias Y2016.Day24
  alias Advent.PathGrid
  doctest Day24

  @sample_input """
  ###########
  #0.1.....2#
  #.#######.#
  #4.......3#
  ###########
  """

  test "verification, part 1", do: assert(Day24.part1_verify() == 456)
  test "verification, part 2", do: assert(Day24.part2_verify() == 704)

  test "part1/1" do
    result = Day24.parse_input(@sample_input) |> Day24.part1()
    assert result == {["0", "4", "1", "2", "3"], 14}
  end

  test "parse_input/1" do
    units = [
      %PathGrid.Unit{identifier: "0", position: {2, 2}},
      %PathGrid.Unit{identifier: "1", position: {2, 4}},
      %PathGrid.Unit{identifier: "2", position: {2, 10}},
      %PathGrid.Unit{identifier: "3", position: {4, 10}},
      %PathGrid.Unit{identifier: "4", position: {4, 2}}
    ]

    assert %PathGrid{graph: %Graph{}, units: parsed_units} = Day24.parse_input(@sample_input)
    assert Enum.sort(units) == Enum.sort(parsed_units)
  end
end

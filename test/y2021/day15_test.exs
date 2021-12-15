defmodule Y2021.Day15Test do
  use ExUnit.Case, async: true
  alias Y2021.Day15
  doctest Day15

  @test_file "../../../test/y2021/input/day15"

  test "verification, part 1", do: assert(Day15.part1_verify() == 583)

  setup do
    [input: Day15.input(@test_file) |> Day15.parse_input()]
  end

  test "part1/1", %{input: input} do
    assert Day15.part1(input) == 40
  end
end

defmodule Y2022.Day24Test do
  use ExUnit.Case, async: true
  alias Y2022.Day24
  doctest Day24

  test "verification, part 1", do: assert(Day24.part1_verify() == 249)
  test "verification, part 2", do: assert(Day24.part2_verify() == 735)

  @sample_input """
  #.######
  #>>.<^<#
  #.<..<<#
  #>v.><>#
  #<^v^^>#
  ######.#
  """

  test "part1/1" do
    assert 18 == Day24.parse_input(@sample_input) |> Day24.part1()
  end

  test "part2/1" do
    assert 54 == Day24.parse_input(@sample_input) |> Day24.part2()
  end
end

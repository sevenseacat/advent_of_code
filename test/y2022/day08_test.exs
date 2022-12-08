defmodule Y2022.Day08Test do
  use ExUnit.Case, async: true
  alias Y2022.Day08
  doctest Day08

  test "verification, part 1", do: assert(Day08.part1_verify() == 1849)
  test "verification, part 2", do: assert(Day08.part2_verify() == 201_600)

  @input """
  30373
  25512
  65332
  33549
  35390
  """

  test "part1/1" do
    assert 21 == Day08.parse_input(@input) |> Day08.part1()
  end

  test "scenic_score/2" do
    grid = Day08.parse_input(@input)
    assert 4 == Day08.scenic_score({{2, 3}, 5}, grid)
    assert 8 == Day08.scenic_score({{4, 3}, 5}, grid)
  end
end

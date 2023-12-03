defmodule Y2023.Day03Test do
  use ExUnit.Case, async: true
  alias Y2023.Day03
  doctest Day03

  test "verification, part 1", do: assert(Day03.part1_verify() == 536_202)
  test "verification, part 2", do: assert(Day03.part2_verify() == 78_272_573)

  @sample_input """
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
  """

  test "part 1" do
    actual = @sample_input |> Day03.parse_input() |> Day03.part1()
    expected = 4361

    assert actual == expected
  end

  test "part 2" do
    actual = @sample_input |> Day03.parse_input() |> Day03.part2()
    expected = 467_835

    assert actual == expected
  end
end

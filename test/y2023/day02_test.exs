defmodule Y2023.Day02Test do
  use ExUnit.Case, async: true
  alias Y2023.Day02
  doctest Day02

  test "verification, part 1", do: assert(Day02.part1_verify() == 2476)
  # test "verification, part 2", do: assert(Day02.part2_verify() == "update or delete me")

  test "part 1" do
    input = """
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    """

    expected = 8
    actual = input |> Day02.parse_input() |> Day02.part1()

    assert actual == expected
  end
end

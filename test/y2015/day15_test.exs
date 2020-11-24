defmodule Y2015.Day15Test do
  use ExUnit.Case, async: true
  alias Y2015.Day15
  doctest Day15

  test "verification, part 1", do: assert(Day15.part1_verify() == 21_367_368)
  test "verification, part 2", do: assert(Day15.part2_verify() == 1_766_400)

  test "score for cookie" do
    expected = 62_842_880

    result =
      Day15.score_for_cookie(
        [{"Butterscotch", 44}, {"Cinnamon", 56}],
        [
          %{
            name: "Butterscotch",
            capacity: -1,
            durability: -2,
            flavor: 6,
            texture: 3,
            calories: 8
          },
          %{name: "Cinnamon", capacity: 2, durability: 3, flavor: -2, texture: -1, calories: 3}
        ]
      )

    assert expected == result
  end
end

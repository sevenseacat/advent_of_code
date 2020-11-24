defmodule Y2015.Day15Test do
  use ExUnit.Case, async: true
  alias Y2015.Day15
  doctest Day15

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

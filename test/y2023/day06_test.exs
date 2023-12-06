defmodule Y2023.Day06Test do
  use ExUnit.Case, async: true
  alias Y2023.Day06
  doctest Day06

  test "verification, part 1", do: assert(Day06.part1_verify() == 1_084_752)
  test "verification, part 2", do: assert(Day06.part2_verify() == 28_228_952)

  @mapping [
    %{time: 7, distance: 9},
    %{time: 15, distance: 40},
    %{time: 30, distance: 200}
  ]

  test "part 1" do
    assert Day06.part1(@mapping) == 288
  end

  test "part 2" do
    assert Day06.part2(@mapping) == 71503
  end
end

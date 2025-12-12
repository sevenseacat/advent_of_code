defmodule Y2024.Day22Test do
  use ExUnit.Case, async: true
  alias Y2024.Day22
  doctest Day22

  test "verification, part 1", do: assert(Day22.part1_verify() == 17_005_483_322)

  @tag timeout: :infinity
  test "verification, part 2", do: assert(Day22.part2_verify() == 1910)
end

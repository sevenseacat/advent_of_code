defmodule Y2025.Day02Test do
  use ExUnit.Case, async: true
  alias Y2025.Day02
  doctest Day02

  test "verification, part 1", do: assert(Day02.part1_verify() == 37_314_786_486)
  # test "verification, part 2", do: assert(Day02.part2_verify() == "update or delete me")
end

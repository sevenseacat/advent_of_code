defmodule Y2019.Day21Test do
  use ExUnit.Case, async: false
  alias Y2019.Day21
  doctest Day21

  test "verification, part 1", do: assert(Day21.part1_verify() == 19_349_939)
  # test "verification, part 2", do: assert(Day21.part2_verify() == "update or delete me")
end

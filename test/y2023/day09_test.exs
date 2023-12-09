defmodule Y2023.Day09Test do
  use ExUnit.Case, async: true
  alias Y2023.Day09
  doctest Day09

  test "verification, part 1", do: assert(Day09.part1_verify() == 1_877_825_184)
  # test "verification, part 2", do: assert(Day09.part2_verify() == "update or delete me")
end

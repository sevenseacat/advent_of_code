defmodule Y2019.Day05Test do
  use ExUnit.Case, async: true
  alias Y2019.Day05
  doctest Day05

  test "verification, part 1", do: assert(Day05.part1_verify() == 6_745_903)
end

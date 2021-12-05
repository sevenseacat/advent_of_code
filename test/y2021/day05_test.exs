defmodule Y2021.Day05Test do
  use ExUnit.Case, async: true
  alias Y2021.Day05
  doctest Day05

  test "verification, part 1", do: assert(Day05.part1_verify() == 6311)
end

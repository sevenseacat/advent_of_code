defmodule Y2021.Day02Test do
  use ExUnit.Case, async: true
  alias Y2021.Day02
  doctest Day02

  test "verification, part 1", do: assert(Day02.part1_verify() == 1_728_414)
end

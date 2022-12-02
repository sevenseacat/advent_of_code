defmodule Y2022.Day02Test do
  use ExUnit.Case, async: true
  alias Y2022.Day02
  doctest Day02

  test "verification, part 1", do: assert(Day02.part1_verify() == 12679)
end

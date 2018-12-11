defmodule Y2018.Day11Test do
  use ExUnit.Case, async: true
  alias Y2018.Day11
  doctest Day11

  test "verification, part 1", do: assert(Day11.part1_verify() == {34, 72})
end

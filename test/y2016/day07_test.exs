defmodule Y2016.Day07Test do
  use ExUnit.Case, async: true
  alias Y2016.Day07
  doctest Day07

  test "verification, part 1", do: assert(Day07.part1_verify() == 118)
end
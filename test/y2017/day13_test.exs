defmodule Y2017.Day13Test do
  use ExUnit.Case, async: true
  alias Y2017.Day13
  alias Y2017.Day13.Layer
  doctest Day13

  test "verification, part 1", do: assert(Day13.part1_verify() == 1580)
end

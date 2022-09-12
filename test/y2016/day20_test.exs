defmodule Y2016.Day20Test do
  use ExUnit.Case, async: true
  alias Y2016.Day20
  doctest Day20

  test "verification, part 1", do: assert(Day20.part1_verify() == 4_793_564)
end

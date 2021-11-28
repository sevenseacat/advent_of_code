defmodule Y2015.Day23Test do
  use ExUnit.Case, async: true
  alias Y2015.Day23
  doctest Day23

  test "verification, part 1", do: assert(Day23.part1_verify() == 184)
end

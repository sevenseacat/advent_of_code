defmodule Y2017.Day23Test do
  use ExUnit.Case, async: true
  alias Y2017.Day23
  doctest Day23

  test "verification, part 1", do: assert(Day23.part1_verify() == 3969)
end

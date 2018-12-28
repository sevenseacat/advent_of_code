defmodule Y2018.Day22Test do
  use ExUnit.Case, async: true
  alias Y2018.Day22
  doctest Day22

  test "verification, part 1", do: assert(Day22.part1_verify() == 11810)
end

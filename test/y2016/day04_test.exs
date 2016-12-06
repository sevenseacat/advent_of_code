defmodule Y2016.Day04Test do
  use ExUnit.Case, async: true
  alias Y2016.Day04
  doctest Day04

  test "verification, part 1", do: assert(Day04.part1_verify() == 158_835)
end

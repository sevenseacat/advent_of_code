defmodule Y2018.Day16Test do
  use ExUnit.Case, async: true
  alias Y2018.Day16
  doctest Day16

  test "verification, part 1", do: assert(Day16.part1_verify() == 588)
end

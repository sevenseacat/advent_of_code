defmodule Y2017.Day03Test do
  use ExUnit.Case, async: true
  alias Y2017.Day03
  doctest Day03

  test "verification, part 1", do: assert(Day03.part1_verify() == 475)
end

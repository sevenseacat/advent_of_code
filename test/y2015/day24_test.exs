defmodule Y2015.Day24Test do
  use ExUnit.Case, async: true
  alias Y2015.Day24
  doctest Day24

  test "verification, part 1", do: assert(Day24.part1_verify() == 11_846_773_891)
end

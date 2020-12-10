defmodule Y2020.Day10Test do
  use ExUnit.Case, async: true
  alias Y2020.Day10
  doctest Day10

  test "verification, part 1", do: assert(Day10.part1_verify() == 1980)
end

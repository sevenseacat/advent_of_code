defmodule Y2019.Day08Test do
  use ExUnit.Case, async: true
  alias Y2019.Day08
  doctest Day08

  test "verification, part 1", do: assert(Day08.part1_verify() == 2193)
end

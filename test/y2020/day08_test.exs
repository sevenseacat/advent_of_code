defmodule Y2020.Day08Test do
  use ExUnit.Case, async: true
  alias Y2020.Day08
  doctest Day08

  test "verification, part 1", do: assert(Day08.part1_verify() == 1684)
end

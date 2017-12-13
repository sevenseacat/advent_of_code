defmodule Y2017.Day09Test do
  use ExUnit.Case, async: true
  alias Y2017.Day09
  doctest Day09

  test "verification, part 1", do: assert(Day09.part1_verify() == 16869)
end

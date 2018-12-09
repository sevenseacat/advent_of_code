defmodule Y2018.Day09Test do
  use ExUnit.Case, async: true
  alias Y2018.Day09
  doctest Day09

  test "verification, part 1", do: assert(Day09.part1_verify() == 399_645)
end

defmodule Y2020.Day09Test do
  use ExUnit.Case, async: true
  alias Y2020.Day09
  doctest Day09

  test "verification, part 1", do: assert(Day09.part1_verify() == 776_203_571)
end

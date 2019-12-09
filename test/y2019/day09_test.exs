defmodule Y2019.Day09Test do
  use ExUnit.Case, async: true
  alias Y2019.Day09
  doctest Day09

  test "verification, part 1", do: assert(Day09.part1_verify() == 2_775_723_069)
end

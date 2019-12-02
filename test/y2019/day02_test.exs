defmodule Y2019.Day02Test do
  use ExUnit.Case, async: true
  alias Y2019.Day02
  doctest Day02

  test "verification, part 1", do: assert(Day02.part1_verify() == 3_224_742)
end

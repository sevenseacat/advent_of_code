defmodule Y2018.Day02Test do
  use ExUnit.Case, async: true
  alias Y2018.Day02
  doctest Day02

  test "verification, part 1", do: assert(Day02.part1_verify() == 5904)
  test "verification, part 2", do: assert(Day02.part2_verify() == "jiwamotgsfrudclzbyzkhlrvp")
end

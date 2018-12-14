defmodule Y2018.Day14Test do
  use ExUnit.Case, async: true
  alias Y2018.Day14
  doctest Day14

  test "verification, part 1", do: assert(Day14.part1_verify() == "1132413111")
end

defmodule Y2020.Day06Test do
  use ExUnit.Case, async: true
  alias Y2020.Day06
  doctest Day06

  test "verification, part 1", do: assert(Day06.part1_verify() == 6680)
end

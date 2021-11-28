defmodule Y2015.Day20Test do
  use ExUnit.Case, async: true
  alias Y2015.Day20
  doctest Day20

  test "verification, part 1", do: assert(Day20.part1_verify() == 831_600)
end

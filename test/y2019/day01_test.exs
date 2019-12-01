defmodule Y2019.Day01Test do
  use ExUnit.Case, async: true
  alias Y2019.Day01
  doctest Day01

  test "verification, part 1", do: assert(Day01.part1_verify() == 3_299_598)
end

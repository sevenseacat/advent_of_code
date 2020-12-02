defmodule Y2020.Day02Test do
  use ExUnit.Case, async: true
  alias Y2020.Day02
  doctest Day02

  test "verification, part 1", do: assert(Day02.part1_verify() == 636)
end

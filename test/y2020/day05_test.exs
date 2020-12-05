defmodule Y2020.Day05Test do
  use ExUnit.Case, async: true
  alias Y2020.Day05
  doctest Day05

  test "verification, part 1", do: assert(Day05.part1_verify() == 976)
end

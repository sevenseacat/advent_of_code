defmodule Y2016.Day25Test do
  use ExUnit.Case, async: true
  alias Y2016.Day25
  doctest Day25

  test "verification, part 1", do: assert(Day25.part1_verify() == 198)
end

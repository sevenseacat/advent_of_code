defmodule Y2016.Day19Test do
  use ExUnit.Case, async: true
  alias Y2016.Day19
  doctest Day19

  test "verification, part 1", do: assert(Day19.part1_verify() == 1_842_613)
end

defmodule Y2018.Day07Test do
  use ExUnit.Case, async: true
  alias Y2018.Day07
  doctest Day07

  test "verification, part 1", do: assert(Day07.part1_verify() == "JMQZELVYXTIGPHFNSOADKWBRUC")
end

defmodule Y2021.Day07Test do
  use ExUnit.Case, async: true
  alias Y2021.Day07
  doctest Day07

  test "verification, part 1", do: assert(Day07.part1_verify() == 352_331)
end

defmodule Y2021.Day24Test do
  use ExUnit.Case, async: true
  alias Y2021.Day24
  doctest Day24

  test "verification, part 1", do: assert(Day24.part1_verify() == "99995969919326")
  test "verification, part 2", do: assert(Day24.part2_verify() == "48111514719111")
end

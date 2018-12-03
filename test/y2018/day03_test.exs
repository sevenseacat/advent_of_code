defmodule Y2018.Day03Test do
  use ExUnit.Case, async: true
  alias Y2018.Day03
  doctest Day03

  test "verification, part 1", do: assert(Day03.part1_verify() == 116_489)
end

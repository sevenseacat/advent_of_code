defmodule Y2022.Day03Test do
  use ExUnit.Case, async: true
  alias Y2022.Day03
  doctest Day03

  test "verification, part 1", do: assert(Day03.part1_verify() == 8153)
end

defmodule Y2021.Day06Test do
  use ExUnit.Case, async: true
  alias Y2021.Day06
  doctest Day06

  test "verification, part 1", do: assert(Day06.part1_verify() == 386_755)
  test "verification, part 2", do: assert(Day06.part2_verify() == 1_732_731_810_807)
end

defmodule Y2018.Day21Test do
  use ExUnit.Case, async: true
  alias Y2018.Day21
  doctest Day21

  test "verification, part 1", do: assert(Day21.part1_verify() == 986_758)

  @tag timeout: :infinity
  test "verification, part 2", do: assert(Day21.part2_verify() == 16_016_565)
end

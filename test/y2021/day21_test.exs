defmodule Y2021.Day21Test do
  use ExUnit.Case, async: true
  alias Y2021.Day21
  doctest Day21

  test "verification, part 1", do: assert(Day21.part1_verify() == 893_700)
  test "verification, part 2", do: assert(Day21.part2_verify() == 568_867_175_661_958)
end

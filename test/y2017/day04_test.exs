defmodule Y2017.Day04Test do
  use ExUnit.Case, async: true
  alias Y2017.Day04
  doctest Day04

  test "verification, part 1", do: assert(Day04.part1_verify() == 337)
  test "verification, part 2", do: assert(Day04.part2_verify() == 231)

  test "example part 1" do
    assert Day04.part1("aa bb cc dd ee\naa bb cc dd aa\naa bb cc dd aaa") == 2
  end
end

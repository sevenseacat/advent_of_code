defmodule Y2015.Day08Test do
  use ExUnit.Case, async: true
  alias Y2015.Day08
  doctest Day08

  test "sample input" do
    assert Day08.part1("test/y2015/input/day08.txt") == 12
  end
end

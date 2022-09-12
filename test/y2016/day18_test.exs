defmodule Y2016.Day18Test do
  use ExUnit.Case, async: true
  alias Y2016.Day18
  doctest Day18

  test "verification, part 1", do: assert(Day18.part1_verify() == 1989)

  describe "part1/2" do
    test "small input" do
      assert Day18.part1("..^^.", 3) == 6
      assert Day18.part1(".^^.^.^^^^", 10) == 38
    end
  end

  describe "next_row/2" do
    test "sample input" do
      assert Day18.next_row([:s, :s, :t, :t, :s]) == [:s, :t, :t, :t, :t]
      assert Day18.next_row([:s, :t, :t, :t, :t]) == [:t, :t, :s, :s, :t]
    end
  end
end

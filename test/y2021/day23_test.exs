defmodule Y2021.Day23Test do
  use ExUnit.Case, async: true
  alias Y2021.Day23
  doctest Day23

  test "verification, part 1", do: assert(Day23.part1_verify() == 15338)
  test "verification, part 2", do: assert(Day23.part2_verify() == 47064)

  describe "parts/1" do
    test "part 1 sample input" do
      result = Day23.part1_input(:sample) |> Day23.parts()
      assert result == 12521
    end

    test "part 2 sample input" do
      result = Day23.part2_input(:sample) |> Day23.parts()
      assert result == 44169
    end
  end
end

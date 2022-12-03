defmodule Y2016.Day23Test do
  use ExUnit.Case, async: true
  alias Y2016.{Day12, Day23}
  doctest Day23

  test "verification, part 1", do: assert(Day23.part1_verify() == 13468)

  @skip
  test "verification, part 2", do: assert(Day23.part2_verify() == 479_010_028)

  describe "part1/1" do
    test "sample" do
      input = """
      cpy 2 a
      tgl a
      tgl a
      tgl a
      cpy 1 a
      dec a
      dec a
      """

      result = Day12.parse_input(input) |> Day12.run_assembunny_code() |> elem(0)
      assert result == 3
    end
  end
end

defmodule Y2024.Day24Test do
  use ExUnit.Case, async: true
  alias Y2024.Day24
  doctest Day24

  test "verification, part 1", do: assert(Day24.part1_verify() == 65_740_327_379_952)
  # test "verification, part 2", do: assert(Day24.part2_verify() == "update or delete me")

  @sample_small """
  x00: 1
  x01: 1
  x02: 1
  y00: 0
  y01: 1
  y02: 0

  x00 AND y00 -> z00
  x01 XOR y01 -> z01
  x02 OR y02 -> z02
  """

  test "parse_input" do
    answer = Day24.parse_input(@sample_small)

    assert answer == {
             %{"x00" => 1, "x01" => 1, "x02" => 1, "y00" => 0, "y01" => 1, "y02" => 0},
             [
               {"x00", "AND", "y00", "z00"},
               {"x01", "XOR", "y01", "z01"},
               {"x02", "OR", "y02", "z02"}
             ]
           }
  end

  test "part1 - small" do
    answer = Day24.parse_input(@sample_small) |> Day24.part1()
    assert answer == 4
  end
end

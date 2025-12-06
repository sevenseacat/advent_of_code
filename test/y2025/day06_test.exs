defmodule Y2025.Day06Test do
  use ExUnit.Case, async: true
  alias Y2025.Day06
  doctest Day06

  test "verification, part 1", do: assert(Day06.part1_verify() == 5_316_572_080_628)
  test "verification, part 2", do: assert(Day06.part2_verify() == 11_299_263_623_062)

  @sample """
  123 328  51 64
   45 64  387 23
    6 98  215 314
  *   +   *   +
  """

  test "parse_input (part 1)" do
    answer = Day06.parse_input(@sample)

    assert answer == [
             {[123, 45, 6], :*},
             {[328, 64, 98], :+},
             {[51, 387, 215], :*},
             {[64, 23, 314], :+}
           ]
  end

  test "parse_input (part 2)" do
    answer = Day06.parse_input(@sample, :transpose)

    assert answer == [
             {[356, 24, 1], :*},
             {[8, 248, 369], :+},
             {[175, 581, 32], :*},
             {[4, 431, 623], :+}
           ]
  end

  test "part 1" do
    answer = @sample |> Day06.parse_input() |> Day06.parts()
    assert answer == 4_277_556
  end
end

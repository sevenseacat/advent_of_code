defmodule Y2024.Day07Test do
  use ExUnit.Case, async: true
  alias Y2024.Day07
  doctest Day07

  @input """
  190: 10 19
  3267: 81 40 27
  83: 17 5
  156: 15 6
  7290: 6 8 6 15
  161011: 16 10 13
  192: 17 8 14
  21037: 9 7 18 13
  292: 11 6 16 20
  """

  test "part 1" do
    assert Day07.parse_input(@input) |> Day07.part1() == 3749
  end

  test "part 2" do
    assert Day07.parse_input(@input) |> Day07.part2() == 11387
  end

  test "valid?" do
    operands1 = [&Kernel.+/2, &Kernel.*/2]
    operands2 = [&Kernel.+/2, &Kernel.*/2, &Day07.concat/2]
    assert Day07.valid?({190, [10, 19]}, operands1)
    assert Day07.valid?({3267, [81, 40, 27]}, operands1)
    refute Day07.valid?({2_939_907_585_850, [8, 8, 957, 6, 1, 1, 2, 4, 2, 3, 1, 8]}, operands2)
  end

  test "verification, part 1", do: assert(Day07.part1_verify() == 2_437_272_016_585)
  test "verification, part 2", do: assert(Day07.part2_verify() == 162_987_117_690_649)
end

defmodule Y2023.Day07Test do
  use ExUnit.Case, async: true
  alias Y2023.Day07
  doctest Day07

  test "verification, part 1", do: assert(Day07.part1_verify() == 250_898_830)
  # test "verification, part 2", do: assert(Day07.part2_verify() == "update or delete me")

  @sample_input """
  32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483
  """

  test "part 1" do
    actual = @sample_input |> Day07.parse_input() |> Day07.part1()
    expected = 6440

    assert actual == expected
  end
end

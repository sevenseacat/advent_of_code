defmodule Y2022.Day20Test do
  use ExUnit.Case, async: true
  alias Y2022.Day20
  doctest Day20

  test "verification, part 1", do: assert(Day20.part1_verify() == 2275)
  # test "verification, part 2", do: assert(Day20.part2_verify() == "update or delete me")

  test "next_position/1" do
    # All the moves from the example
    assert 1 == Day20.next_position(length: 7, item: 1, current: 0)
    assert 2 == Day20.next_position(length: 7, item: 2, current: 0)
    assert 4 == Day20.next_position(length: 7, item: -3, current: 1)
    assert 5 == Day20.next_position(length: 7, item: 3, current: 2)
    assert 6 == Day20.next_position(length: 7, item: -2, current: 2)
    assert 3 == Day20.next_position(length: 7, item: 0, current: 3)
    assert 3 == Day20.next_position(length: 7, item: 4, current: 5)

    # All other cases that raised bugs
    # [0, 1, 2, 3, 4, 5, x] (when run as part of a mix) has the x at position 5
    # when it's time to mix that item
    assert 6 == Day20.next_position(length: 7, item: 1, current: 5)
    assert 1 == Day20.next_position(length: 7, item: 2, current: 5)
    assert 2 == Day20.next_position(length: 7, item: 3, current: 5)
    assert 3 == Day20.next_position(length: 7, item: 4, current: 5)
    assert 4 == Day20.next_position(length: 7, item: 5, current: 5)
    assert 5 == Day20.next_position(length: 7, item: 6, current: 5)
    assert 6 == Day20.next_position(length: 7, item: 7, current: 5)
    assert 1 == Day20.next_position(length: 7, item: 8, current: 5)
    assert 2 == Day20.next_position(length: 7, item: 9, current: 5)
    assert 3 == Day20.next_position(length: 7, item: 10, current: 5)
    assert 4 == Day20.next_position(length: 7, item: -7, current: 5)
    assert 3 == Day20.next_position(length: 7, item: -8, current: 5)
    assert 1 == Day20.next_position(length: 7, item: -10, current: 5)
    assert 6 == Day20.next_position(length: 7, item: -11, current: 5)
    assert 5 == Day20.next_position(length: 7, item: -12, current: 5)
    assert 2 == Day20.next_position(length: 7, item: -15, current: 5)
  end
end

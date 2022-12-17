defmodule Y2022.Day17Test do
  use ExUnit.Case, async: true
  alias Y2022.Day17
  doctest Day17

  test "verification, part 1", do: assert(Day17.part1_verify() == 3106)
  # test "verification, part 2", do: assert(Day17.part2_verify() == "update or delete me")

  @sample_input ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"

  test "part1/1" do
    assert 1 == Day17.parse_input(@sample_input) |> Day17.part1(1)
    assert 4 == Day17.parse_input(@sample_input) |> Day17.part1(2)
    assert 6 == Day17.parse_input(@sample_input) |> Day17.part1(3)
    assert 7 == Day17.parse_input(@sample_input) |> Day17.part1(4)
    assert 9 == Day17.parse_input(@sample_input) |> Day17.part1(5)
    assert 10 == Day17.parse_input(@sample_input) |> Day17.part1(6)
    assert 13 == Day17.parse_input(@sample_input) |> Day17.part1(7)
    assert 15 == Day17.parse_input(@sample_input) |> Day17.part1(8)
    assert 17 == Day17.parse_input(@sample_input) |> Day17.part1(9)
    assert 17 == Day17.parse_input(@sample_input) |> Day17.part1(10)

    assert 3068 == Day17.parse_input(@sample_input) |> Day17.part1()
  end

  describe "drop_piece/4" do
    test "dropping a few pieces" do
      input = Day17.parse_input(@sample_input)
      size = map_size(input)

      one_drop = {MapSet.new([{1, 3}, {1, 4}, {1, 5}, {1, 6}]), 1}
      assert one_drop == Day17.drop_piece({input, 0, size}, {0, 1}, {MapSet.new(), 0})

      two_drops =
        {MapSet.new([{1, 3}, {1, 4}, {1, 5}, {1, 6}, {2, 4}, {3, 3}, {3, 4}, {3, 5}, {4, 4}]), 4}

      assert two_drops == Day17.drop_piece({input, 4, size}, {1, 2}, one_drop)
    end
  end
end

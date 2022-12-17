defmodule Y2022.Day17Test do
  use ExUnit.Case, async: true
  alias Y2022.Day17
  doctest Day17

  test "verification, part 1", do: assert(Day17.part1_verify() == 3106)
  test "verification, part 2", do: assert(Day17.part2_verify() == 1_537_175_792_495)

  @sample_input ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"

  test "parts/1" do
    assert 1 == Day17.parse_input(@sample_input) |> Day17.parts(1)
    assert 4 == Day17.parse_input(@sample_input) |> Day17.parts(2)
    assert 6 == Day17.parse_input(@sample_input) |> Day17.parts(3)
    assert 7 == Day17.parse_input(@sample_input) |> Day17.parts(4)
    assert 9 == Day17.parse_input(@sample_input) |> Day17.parts(5)
    assert 10 == Day17.parse_input(@sample_input) |> Day17.parts(6)
    assert 13 == Day17.parse_input(@sample_input) |> Day17.parts(7)
    assert 15 == Day17.parse_input(@sample_input) |> Day17.parts(8)
    assert 17 == Day17.parse_input(@sample_input) |> Day17.parts(9)
    assert 17 == Day17.parse_input(@sample_input) |> Day17.parts(10)

    assert 3068 == Day17.parse_input(@sample_input) |> Day17.parts(2022)

    assert 1_514_285_714_288 == Day17.parse_input(@sample_input) |> Day17.parts(1_000_000_000_000)
  end

  describe "drop_piece/4" do
    test "dropping a few pieces" do
      input = Day17.parse_input(@sample_input)
      size = map_size(input)
      dummy_cache = {Map.new(), Map.new(1..7, &{&1, -1})}

      one_drop = {MapSet.new([{1, 3}, {1, 4}, {1, 5}, {1, 6}]), 1}

      assert one_drop ==
               Day17.drop_piece({input, 0, size}, {0, 1}, {MapSet.new(), 0}, dummy_cache)

      two_drops =
        {MapSet.new([{1, 3}, {1, 4}, {1, 5}, {1, 6}, {2, 4}, {3, 3}, {3, 4}, {3, 5}, {4, 4}]), 4}

      assert two_drops == Day17.drop_piece({input, 4, size}, {1, 2}, one_drop, dummy_cache)
    end
  end
end

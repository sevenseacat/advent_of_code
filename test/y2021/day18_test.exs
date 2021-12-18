defmodule Y2021.Day18Test do
  use ExUnit.Case, async: true
  alias Y2021.Day18
  doctest Day18

  test "verification, part 1", do: assert(Day18.part1_verify() == 4088)
  test "verification, part 2", do: assert(Day18.part2_verify() == 4536)

  test "part1/1" do
    input = [
      [[[0, [5, 8]], [[1, 7], [9, 6]]], [[4, [1, 2]], [[1, 4], 2]]],
      [[[5, [2, 8]], 4], [5, [[9, 9], 0]]],
      [6, [[[6, 2], [5, 6]], [[7, 6], [4, 7]]]],
      [[[6, [0, 7]], [0, 9]], [4, [9, [9, 0]]]],
      [[[7, [6, 4]], [3, [1, 3]]], [[[5, 5], 1], 9]],
      [[6, [[7, 3], [3, 2]]], [[[3, 8], [5, 7]], 4]],
      [[[[5, 4], [7, 7]], 8], [[8, 3], 8]],
      [[9, 3], [[9, 9], [6, [4, 9]]]],
      [[2, [[7, 7], 7]], [[5, 8], [[9, 3], [0, 2]]]],
      [[[[5, 2], 5], [8, [3, 7]]], [[5, [7, 5]], [4, 4]]]
    ]

    assert Day18.part1(input) == 4140
  end

  test "part2/1" do
    input = [
      [[[0, [5, 8]], [[1, 7], [9, 6]]], [[4, [1, 2]], [[1, 4], 2]]],
      [[[5, [2, 8]], 4], [5, [[9, 9], 0]]],
      [6, [[[6, 2], [5, 6]], [[7, 6], [4, 7]]]],
      [[[6, [0, 7]], [0, 9]], [4, [9, [9, 0]]]],
      [[[7, [6, 4]], [3, [1, 3]]], [[[5, 5], 1], 9]],
      [[6, [[7, 3], [3, 2]]], [[[3, 8], [5, 7]], 4]],
      [[[[5, 4], [7, 7]], 8], [[8, 3], 8]],
      [[9, 3], [[9, 9], [6, [4, 9]]]],
      [[2, [[7, 7], 7]], [[5, 8], [[9, 3], [0, 2]]]],
      [[[[5, 2], 5], [8, [3, 7]]], [[5, [7, 5]], [4, 4]]]
    ]

    assert Day18.part2(input) == 3993
  end

  describe "final_sum/1" do
    test "example 1" do
      input = [[1, 1], [2, 2], [3, 3], [4, 4]]
      assert Day18.final_sum(input) == [[[[1, 1], [2, 2]], [3, 3]], [4, 4]]
    end

    test "example 2" do
      input = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5]]
      assert Day18.final_sum(input) == [[[[3, 0], [5, 3]], [4, 4]], [5, 5]]
    end

    test "example 3" do
      input = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6]]
      assert Day18.final_sum(input) == [[[[5, 0], [7, 4]], [5, 5]], [6, 6]]
    end

    test "big example broken up" do
      input = [
        [[[0, [4, 5]], [0, 0]], [[[4, 5], [2, 6]], [9, 5]]],
        [7, [[[3, 7], [4, 3]], [[6, 3], [8, 8]]]]
      ]

      expected = [[[[4, 0], [5, 4]], [[7, 7], [6, 0]]], [[8, [7, 7]], [[7, 9], [5, 0]]]]
      assert Day18.final_sum(input) == expected
    end

    test "big example" do
      input = [
        [[[0, [4, 5]], [0, 0]], [[[4, 5], [2, 6]], [9, 5]]],
        [7, [[[3, 7], [4, 3]], [[6, 3], [8, 8]]]],
        [[2, [[0, 8], [3, 4]]], [[[6, 7], 1], [7, [1, 6]]]],
        [[[[2, 4], 7], [6, [0, 5]]], [[[6, 8], [2, 8]], [[2, 1], [4, 5]]]],
        [7, [5, [[3, 8], [1, 4]]]],
        [[2, [2, 2]], [8, [8, 1]]],
        [2, 9],
        [1, [[[9, 3], 9], [[9, 0], [0, 7]]]],
        [[[5, [7, 4]], 7], 1],
        [[[[4, 2], 2], 6], [8, 7]]
      ]

      expected = [[[[8, 7], [7, 7]], [[8, 6], [7, 7]]], [[[0, 7], [6, 6]], [8, 7]]]

      assert Day18.final_sum(input) == expected
    end
  end

  describe "explode/1" do
    test "example 1" do
      assert Day18.explode([[[[[9, 8], 1], 2], 3], 4]) == [[[[0, 9], 2], 3], 4]
    end

    test "example 2" do
      assert Day18.explode([7, [6, [5, [4, [3, 2]]]]]) == [7, [6, [5, [7, 0]]]]
    end

    test "example 3" do
      assert Day18.explode([[6, [5, [4, [3, 2]]]], 1]) == [[6, [5, [7, 0]]], 3]
    end

    test "example 4" do
      input = [[3, [2, [1, [7, 3]]]], [6, [5, [4, [3, 2]]]]]
      expected = [[3, [2, [8, 0]]], [9, [5, [4, [3, 2]]]]]
      assert Day18.explode(input) == expected
    end

    test "example 5" do
      input = [[3, [2, [8, 0]]], [9, [5, [4, [3, 2]]]]]
      expected = [[3, [2, [8, 0]]], [9, [5, [7, 0]]]]
      assert Day18.explode(input) == expected
    end
  end

  describe "maybe_split/1" do
    test "example 1" do
      assert Day18.maybe_split([15, [0, 13]]) == [[7, 8], [0, 13]]
      assert Day18.maybe_split([[7, 8], [0, 13]]) == [[7, 8], [0, [6, 7]]]
    end
  end

  describe "magnitude/1" do
    test "example 1" do
      assert Day18.magnitude([[1, 2], [[3, 4], 5]]) == 143
    end

    test "example 2" do
      assert Day18.magnitude([[[[0, 7], 4], [[7, 8], [6, 0]]], [8, 1]]) == 1384
    end

    test "example 3" do
      assert Day18.magnitude([[[[1, 1], [2, 2]], [3, 3]], [4, 4]]) == 445
    end

    test "example 4" do
      assert Day18.magnitude([[[[3, 0], [5, 3]], [4, 4]], [5, 5]]) == 791
    end

    test "example 5" do
      assert Day18.magnitude([[[[5, 0], [7, 4]], [5, 5]], [6, 6]]) == 1137
    end

    test "example 6" do
      input = [[[[8, 7], [7, 7]], [[8, 6], [7, 7]]], [[[0, 7], [6, 6]], [8, 7]]]
      assert Day18.magnitude(input) == 3488
    end
  end
end

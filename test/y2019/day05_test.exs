defmodule Y2019.Day05Test do
  use ExUnit.Case, async: true
  alias Y2019.Day05
  doctest Day05

  test "verification, part 1", do: assert(Day05.part1_verify() == 6_745_903)
  test "verification, part 2", do: assert(Day05.part2_verify() == 9_168_267)

  describe "run_program/4" do
    test "basic input 1 from day 2" do
      {:halt, actual} = Day05.run_program(:array.from_list([1, 0, 0, 0, 99]))
      assert {[2, 0, 0, 0, 99], []} == actual
    end

    test "basic input 2 from day 2" do
      {:halt, actual} = Day05.run_program(:array.from_list([2, 3, 0, 3, 99]))
      assert {[2, 3, 0, 6, 99], []} == actual
    end

    test "basic input 3 from day 2" do
      {:halt, actual} = Day05.run_program(:array.from_list([2, 4, 4, 5, 99, 0]))
      assert {[2, 4, 4, 5, 99, 9801], []} == actual
    end

    test "basic input 4 from day 2" do
      {:halt, actual} = Day05.run_program(:array.from_list([1, 1, 1, 4, 99, 5, 6, 0, 99]))
      assert {[30, 1, 1, 4, 2, 5, 6, 0, 99], []} == actual
    end

    test "an input that has an output" do
      {:halt, actual} = Day05.run_program(:array.from_list([3, 0, 4, 0, 99]), [444])
      assert {[444, 0, 4, 0, 99], [444]} == actual
    end

    test "an input with modes" do
      {:halt, actual} = Day05.run_program(:array.from_list([1002, 4, 3, 4, 33]))
      assert {[1002, 4, 3, 4, 99], []} == actual
    end

    test "jump test #1 - position mode" do
      {:halt, {_program, outputs}} =
        Day05.run_program(
          :array.from_list([3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9]),
          [0]
        )

      assert outputs == [0]
    end

    test "jump test #2 - position mode" do
      {:halt, {_program, outputs}} =
        Day05.run_program(
          :array.from_list([3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9]),
          [42]
        )

      assert outputs == [1]
    end

    test "jump test #1 - immediate mode" do
      {:halt, {_program, outputs}} =
        Day05.run_program(:array.from_list([3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1]), [0])

      assert outputs == [0]
    end

    test "jump test #2 - immediate mode" do
      {:halt, {_program, outputs}} =
        Day05.run_program(:array.from_list([3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1]), [
          42
        ])

      assert outputs == [1]
    end

    test "equal test #1 - is equal to 8" do
      {:halt, {_program, outputs}} =
        Day05.run_program(:array.from_list([3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8]), [8])

      assert outputs == [1]
    end

    test "equal test #1 - is not equal to 8" do
      {:halt, {_program, outputs}} =
        Day05.run_program(:array.from_list([3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8]), [33])

      assert outputs == [0]
    end

    test "less than test #1 - is less than 8" do
      {:halt, {_program, outputs}} =
        Day05.run_program(:array.from_list([3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8]), [2])

      assert outputs == [1]
    end

    test "less than test #1 - is not less than 8" do
      {:halt, {_program, outputs}} =
        Day05.run_program(:array.from_list([3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8]), [8])

      assert outputs == [0]
    end

    test "equal test #2 - is equal to 8" do
      {:halt, {_program, outputs}} =
        Day05.run_program(:array.from_list([3, 3, 1108, -1, 8, 3, 4, 3, 99]), [8])

      assert outputs == [1]
    end

    test "equal test #2 - is not equal to 8" do
      {:halt, {_program, outputs}} =
        Day05.run_program(:array.from_list([3, 3, 1108, -1, 8, 3, 4, 3, 99]), [1])

      assert outputs == [0]
    end

    test "less than test #2 - is less than 8" do
      {:halt, {_program, outputs}} =
        Day05.run_program(:array.from_list([3, 3, 1107, -1, 8, 3, 4, 3, 99]), [2])

      assert outputs == [1]
    end

    test "less than test #2 - is not less than 8" do
      {:halt, {_program, outputs}} =
        Day05.run_program(:array.from_list([3, 3, 1107, -1, 8, 3, 4, 3, 99]), [8])

      assert outputs == [0]
    end
  end
end

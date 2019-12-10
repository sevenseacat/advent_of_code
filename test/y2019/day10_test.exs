defmodule Y2019.Day10Test do
  use ExUnit.Case, async: true
  alias Y2019.Day10
  doctest Day10

  test "verification, part 1", do: assert(Day10.part1_verify() == 340)

  @sample_input_1 ".#..#\n.....\n#####\n....#\n...##"

  describe "part1/1" do
    test "sample input 1" do
      input = Day10.parse_input(@sample_input_1)
      assert {{3, 4}, 8} == Day10.part1(input)
    end

    test "sample input 2" do
      input = test_data("sample_2") |> Day10.parse_input()
      assert {{5, 8}, 33} == Day10.part1(input)
    end

    test "sample input 3" do
      input = test_data("sample_3") |> Day10.parse_input()
      assert {{1, 2}, 35} == Day10.part1(input)
    end

    test "sample input 4" do
      input = test_data("sample_4") |> Day10.parse_input()
      assert {{6, 3}, 41} == Day10.part1(input)
    end

    test "sample input 5" do
      input = test_data("sample_5") |> Day10.parse_input()
      assert {{11, 13}, 210} == Day10.part1(input)
    end
  end

  describe "seen_count/2" do
    def parsed_sample do
      Day10.parse_input(@sample_input_1)
    end

    test "position 1 in sample input 1" do
      assert 7 == Day10.seen_count(parsed_sample(), {1, 0})
    end

    test "position 2 in sample input 1" do
      assert 7 == Day10.seen_count(parsed_sample(), {4, 0})
    end

    test "position 3 in sample input 1" do
      assert 6 == Day10.seen_count(parsed_sample(), {0, 2})
    end

    test "position 4 in sample input 1" do
      assert 7 == Day10.seen_count(parsed_sample(), {1, 2})
    end

    test "position 5 in sample input 1" do
      assert 7 == Day10.seen_count(parsed_sample(), {2, 2})
    end

    test "position 6 in sample input 1" do
      assert 7 == Day10.seen_count(parsed_sample(), {3, 2})
    end

    test "position 7 in sample input 1" do
      assert 5 == Day10.seen_count(parsed_sample(), {4, 2})
    end

    test "position 8 in sample input 1" do
      assert 7 == Day10.seen_count(parsed_sample(), {4, 3})
    end

    test "position 9 in sample input 1" do
      assert 8 == Day10.seen_count(parsed_sample(), {3, 4})
    end

    test "position 10 in sample input 1" do
      assert 7 == Day10.seen_count(parsed_sample(), {4, 4})
    end
  end

  describe "part2/1" do
    test "large sample from part 1" do
      input = test_data("sample_5") |> Day10.parse_input()

      assert 802 == Day10.part2(input)
    end
  end

  describe "run_laser_simulation/1" do
    test "fire the lazorrrrrr" do
      input = test_data("sample_6") |> Day10.parse_input()

      order_of_destruction = [
        {8, 1},
        {9, 0},
        {9, 1},
        {10, 0},
        {9, 2},
        {11, 1},
        {12, 1},
        {11, 2},
        {15, 1}
      ]

      assert order_of_destruction == Day10.run_laser_simulation(input) |> Enum.take(9)
    end

    test "large input from part 1" do
      input = test_data("sample_5") |> Day10.parse_input()
      order_of_destruction = Day10.run_laser_simulation(input)

      # Remember zero-indexing
      assert {11, 12} == Enum.at(order_of_destruction, 0)
      assert {12, 1} == Enum.at(order_of_destruction, 1)
      assert {12, 2} == Enum.at(order_of_destruction, 2)
      assert {12, 8} == Enum.at(order_of_destruction, 9)
      assert {16, 0} == Enum.at(order_of_destruction, 19)
      assert {16, 9} == Enum.at(order_of_destruction, 49)
      assert {10, 16} == Enum.at(order_of_destruction, 99)
      assert {9, 6} == Enum.at(order_of_destruction, 198)
      assert {8, 2} == Enum.at(order_of_destruction, 199)
      assert {10, 9} == Enum.at(order_of_destruction, 200)
      assert {11, 1} == Enum.at(order_of_destruction, 298)
    end
  end

  def test_data(name), do: File.read!("test/y2019/input/day10/#{name}.txt")
end

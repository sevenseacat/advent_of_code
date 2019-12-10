defmodule Y2019.Day10Test do
  use ExUnit.Case, async: true
  alias Y2019.Day10
  doctest Day10

  test "verification, part 1", do: assert(Day10.part1_verify() == 340)

  @sample_input_1 ".#..#\n.....\n#####\n....#\n...##"

  describe "part1/1" do
    test "sample input 1" do
      assert {{3, 4}, 8} == Day10.part1(@sample_input_1)
    end

    test "sample input 2" do
      input = test_data("sample_2")
      assert {{5, 8}, 33} == Day10.part1(input)
    end

    test "sample input 3" do
      input = test_data("sample_3")
      assert {{1, 2}, 35} == Day10.part1(input)
    end

    test "sample input 4" do
      input = test_data("sample_4")
      assert {{6, 3}, 41} == Day10.part1(input)
    end

    test "sample input 5" do
      input = test_data("sample_5")
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

  def test_data(name), do: File.read!("test/y2019/input/day10/#{name}.txt")
end

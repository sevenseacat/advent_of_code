defmodule Y2019.Day14Test do
  use ExUnit.Case, async: true
  alias Y2019.Day14
  doctest Day14

  test "verification, part 1", do: assert(Day14.part1_verify() == 2_556_890)

  describe "parse_input/1" do
    test "can parse inputs and outputs" do
      actual = test_data("sample_1") |> Day14.parse_input()

      assert [
               {[{"ORE", 10}], {"A", 10}},
               {[{"ORE", 1}], {"B", 1}},
               {[{"A", 7}, {"B", 1}], {"C", 1}},
               {[{"A", 7}, {"C", 1}], {"D", 1}},
               {[{"A", 7}, {"D", 1}], {"E", 1}},
               {[{"A", 7}, {"E", 1}], {"FUEL", 1}}
             ] == actual
    end
  end

  describe "part1/1" do
    test "sample input 1" do
      input = test_data("sample_1") |> Day14.parse_input()
      assert 31 == Day14.part1(input)
    end

    test "sample input 2" do
      input = test_data("sample_2") |> Day14.parse_input()
      assert 165 == Day14.part1(input)
    end

    test "sample input 3" do
      input = test_data("sample_3") |> Day14.parse_input()
      assert 13312 == Day14.part1(input)
    end

    test "sample input 4" do
      input = test_data("sample_4") |> Day14.parse_input()
      assert 180_697 == Day14.part1(input)
    end

    test "sample input 5" do
      input = test_data("sample_5") |> Day14.parse_input()
      assert 2_210_736 == Day14.part1(input)
    end
  end

  def test_data(name), do: File.read!("test/y2019/input/day14/#{name}.txt")
end

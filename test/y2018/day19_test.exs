defmodule Y2018.Day19Test do
  use ExUnit.Case, async: true
  alias Y2018.Day19
  doctest Day19

  test "verification, part 1", do: assert(Day19.part1_verify() == 1860)

  describe "part 1" do
    test "it works with sample input" do
      input = test_data("sample")
      output = [6, 5, 6, 0, 0, 9]

      assert Day19.part1(input) == output
    end
  end

  describe "parse_input" do
    test "it reads the input properly" do
      input = test_data("sample")

      output = %{
        ip: 0,
        commands: %{
          0 => {:seti, 5, 0, 1},
          1 => {:seti, 6, 0, 2},
          2 => {:addi, 0, 1, 0},
          3 => {:addr, 1, 2, 3},
          4 => {:setr, 1, 0, 0},
          5 => {:seti, 8, 0, 4},
          6 => {:seti, 9, 0, 5}
        }
      }

      assert Day19.parse_input(input) == output
    end
  end

  def test_data(name), do: File.read!("test/y2018/input/day19/#{name}.txt")
end

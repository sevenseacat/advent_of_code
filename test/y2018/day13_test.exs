defmodule Y2018.Day13Test do
  use ExUnit.Case, async: true
  alias Y2018.Day13
  doctest Day13

  describe "parse_input/1" do
    test "it parses simple loops" do
      {:ok, input} = test_data("simple_loop")

      expected_output = %{
        {0, 0} => {"/", nil},
        {1, 0} => {"-", nil},
        {2, 0} => {"-", nil},
        {3, 0} => {"-", nil},
        {4, 0} => {"\\", nil},
        {0, 1} => {"|", nil},
        {4, 1} => {"|", nil},
        {0, 2} => {"\\", nil},
        {1, 2} => {"-", nil},
        {2, 2} => {"-", nil},
        {3, 2} => {"-", nil},
        {4, 2} => {"/", nil}
      }

      assert Day13.parse_input(input) == expected_output
    end

    test "it can parse intersections and carts" do
      {:ok, input} = test_data("intersecting_carts")

      expected_output = %{
        {0, 0} => {"/", nil},
        {1, 0} => {"-", nil},
        {2, 0} => {"-", nil},
        {3, 0} => {"-", :right},
        {4, 0} => {"-", nil},
        {5, 0} => {"-", nil},
        {6, 0} => {"\\", nil},
        {0, 1} => {"|", nil},
        {6, 1} => {"|", nil},
        {0, 2} => {"|", nil},
        {3, 2} => {"/", nil},
        {4, 2} => {"-", nil},
        {5, 2} => {"-", nil},
        {6, 2} => {"+", nil},
        {7, 2} => {"-", nil},
        {8, 2} => {"-", nil},
        {9, 2} => {"\\", nil},
        {0, 3} => {"|", nil},
        {3, 3} => {"|", :up},
        {6, 3} => {"|", nil},
        {9, 3} => {"|", nil},
        {0, 4} => {"\\", nil},
        {1, 4} => {"-", nil},
        {2, 4} => {"-", nil},
        {3, 4} => {"+", nil},
        {4, 4} => {"-", nil},
        {5, 4} => {"-", nil},
        {6, 4} => {"/", nil},
        {9, 4} => {"|", nil},
        {3, 5} => {"|", nil},
        {9, 5} => {"|", nil},
        {3, 6} => {"\\", nil},
        {4, 6} => {"-", nil},
        {5, 6} => {"-", nil},
        {6, 6} => {"-", nil},
        {7, 6} => {"-", nil},
        {8, 6} => {"-", nil},
        {9, 6} => {"/", nil}
      }

      assert Day13.parse_input(input) == expected_output
    end
  end

  def test_data(name), do: File.read("test/y2018/input/day13/#{name}.txt")
end

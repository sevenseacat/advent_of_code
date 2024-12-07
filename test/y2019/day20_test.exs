defmodule Y2019.Day20Test do
  use ExUnit.Case, async: true
  alias Y2019.Day20
  doctest Day20

  describe "part 1" do
    test "sample 1" do
      result = test_data("sample_1") |> Day20.parse_input() |> Day20.part1()
      assert result == 23
    end

    test "sample 2" do
      result = test_data("sample_2") |> Day20.parse_input() |> Day20.part1()
      assert result == 58
    end
  end

  test "verification, part 1", do: assert(Day20.part1_verify() == 422)
  # test "verification, part 2", do: assert(Day20.part2_verify() == "update or delete me")

  def test_data(name), do: File.read!("test/y2019/input/day20/#{name}.txt")
end

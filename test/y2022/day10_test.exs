defmodule Y2022.Day10Test do
  use ExUnit.Case, async: true
  alias Y2022.Day10
  doctest Day10

  test "verification, part 1", do: assert(Day10.part1_verify() == 15020)
  # test "verification, part 2", do: assert(Day10.part2_verify() == "update or delete me")

  test "part1/1" do
    assert 13140 == Day10.parse_input(test_data()) |> Day10.part1()
  end

  def test_data(), do: File.read!("test/y2022/input/day10.txt")
end

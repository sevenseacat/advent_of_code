defmodule Y2024.Day18Test do
  use ExUnit.Case, async: true
  alias Y2024.Day18
  doctest Day18

  test "part1" do
    assert test_data() |> Day18.parse_input() |> Day18.part1(6, 12) == 22
  end

  test "verification, part 1", do: assert(Day18.part1_verify() == 436)
  # test "verification, part 2", do: assert(Day18.part2_verify() == "update or delete me")

  def test_data(), do: File.read!("test/y2024/input/day18/sample.txt")
end

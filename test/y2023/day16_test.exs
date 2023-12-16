defmodule Y2023.Day16Test do
  use ExUnit.Case, async: true
  alias Y2023.Day16
  doctest Day16

  test "verification, part 1", do: assert(Day16.part1_verify() == 7482)
  # test "verification, part 2", do: assert(Day16.part2_verify() == "update or delete me")

  test "part 1" do
    actual = test_data("sample") |> Day16.parse_input() |> Day16.part1()
    assert 46 == actual
  end

  def test_data(name), do: File.read!("test/y2023/input/day16/#{name}.txt")
end

defmodule Y2024.Day16Test do
  use ExUnit.Case, async: true
  alias Y2024.Day16
  doctest Day16

  test "part1" do
    assert test_data("sample1") |> Day16.parse_input() |> Day16.part1() == 7036
    assert test_data("sample2") |> Day16.parse_input() |> Day16.part1() == 11048
  end

  test "part2" do
    assert test_data("sample1") |> Day16.parse_input() |> Day16.part2() == 45
    assert test_data("sample2") |> Day16.parse_input() |> Day16.part2() == 64
  end

  test "verification, part 1", do: assert(Day16.part1_verify() == 91464)
  test "verification, part 2", do: assert(Day16.part2_verify() == 494)

  def test_data(name), do: File.read!("test/y2024/input/day16/#{name}.txt")
end

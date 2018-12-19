defmodule Y2018.Day17Test do
  use ExUnit.Case, async: false
  alias Y2018.Day17
  doctest Day17

  test "verification, part 1", do: assert(Day17.part1_verify() == 31013)

  describe "part 1" do
    test "edge case" do
      {from, state} = test_data("edge_case") |> Day17.parse_picture_input()
      assert Day17.part1(state, from) == 337
    end
  end

  def test_data(name), do: File.read!("test/y2018/input/day17/#{name}.txt")
end

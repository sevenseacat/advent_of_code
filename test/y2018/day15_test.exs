defmodule Y2018.Day15Test do
  use ExUnit.Case, async: true
  alias Y2018.{Day15, Day15.Unit}
  doctest Day15

  describe "parse_input" do
    test "it can read a sample grid" do
      {:ok, input} = test_data("parse_input")

      expected_output = {
        # Units
        [
          %Unit{type: :goblin, hp: 200, position: {2, 3}},
          %Unit{type: :elf, hp: 200, position: {2, 5}},
          %Unit{type: :elf, hp: 200, position: {3, 2}},
          %Unit{type: :goblin, hp: 200, position: {3, 4}},
          %Unit{type: :elf, hp: 200, position: {3, 6}},
          %Unit{type: :goblin, hp: 200, position: {4, 3}},
          %Unit{type: :elf, hp: 200, position: {4, 5}}
        ],

        # Movable squares
        MapSet.new([
          {2, 2},
          {2, 3},
          {2, 4},
          {2, 5},
          {2, 6},
          {3, 2},
          {3, 3},
          {3, 4},
          {3, 5},
          {3, 6},
          {4, 2},
          {4, 3},
          {4, 5},
          {4, 6}
        ])
      }

      assert Day15.parse_input(input) == expected_output
    end
  end

  def test_data(name), do: File.read("test/y2018/input/day15/#{name}.txt")
end

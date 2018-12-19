defmodule Y2018.Day18Test do
  use ExUnit.Case, async: true
  alias Y2018.Day18
  doctest Day18

  test "verification, part 1", do: assert(Day18.part1_verify() == 638_400)

  def test_data(name), do: File.read!("test/y2018/input/day18/#{name}.txt")
end

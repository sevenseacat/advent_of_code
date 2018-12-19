defmodule Y2018.Day18Test do
  use ExUnit.Case, async: true
  alias Y2018.Day18
  doctest Day18

  test "verification, part 1", do: assert(Day18.part1_verify() == 638_400)
  test "verification, part 2", do: assert(Day18.part2_verify() == 195_952)

  def test_data(name), do: File.read!("test/y2018/input/day18/#{name}.txt")
end

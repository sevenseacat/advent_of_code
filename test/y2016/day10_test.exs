defmodule Y2016.Day10Test do
  use ExUnit.Case, async: true
  alias Y2016.{Day10, Day10.Bot, Day10.Output}
  doctest Day10

  test "verification, part 1", do: assert(Day10.part1_verify() == 47)
  test "verification, part 2", do: assert(Day10.part2_verify() == 2666)
end

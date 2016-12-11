defmodule Y2016.Day09Test do
  use ExUnit.Case, async: true
  alias Y2016.Day09
  doctest Day09

  test "verification, part 1", do: assert(Day09.part1_verify() == 183_269)
  test "verification, part 2", do: assert(Day09.part2_verify() == 11_317_278_863)
end

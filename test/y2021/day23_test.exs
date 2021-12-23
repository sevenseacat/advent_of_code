defmodule Y2021.Day23Test do
  use ExUnit.Case, async: true
  alias Y2021.Day23
  doctest Day23

  @tag timeout: :infinity
  test "verification, part 1", do: assert(Day23.part1_verify() == 15338)
end

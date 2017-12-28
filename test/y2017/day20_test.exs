defmodule Y2017.Day20Test do
  use ExUnit.Case, async: true
  alias Y2017.Day20
  alias Y2017.Day20.Particle
  doctest Day20

  test "verification, part 1", do: assert(Day20.part1_verify() == 258)
end

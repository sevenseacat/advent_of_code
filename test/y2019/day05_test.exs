defmodule Y2019.Day05Test do
  use ExUnit.Case, async: true
  alias Y2019.Day05
  doctest Day05

  import ExUnit.CaptureIO

  test "verification, part 1", do: assert(capture_io(&Day05.part1_verify/0) == "6745903\n")
end

defmodule Y2019.Day11Test do
  use ExUnit.Case, async: true
  alias Y2019.Day11
  doctest Day11

  import ExUnit.CaptureIO

  test "verification, part 1", do: assert(Day11.part1_verify() == 2293)

  test "verification, part 2" do
    expected = """
    XX..XX.XX.X.XXXXX..XX...XX...XXX..XX.XXXXXX
    X.XX.X.XX.X.XXXX.XX.X.XX.X.XX.X.XX.X.XXXXXX
    X.XX.X....X.XXXX.XXXX.XX.X.XX.X.XX.X.XXXXXX
    X....X.XX.X.XXXX.XXXX...XX...XX....X.XXXXXX
    X.XX.X.XX.X.XXXX.XX.X.XXXX.X.XX.XX.X.XXXXXX
    X.XX.X.XX.X....XX..XX.XXXX.XX.X.XX.X....XXX
    """

    assert(capture_io(&Day11.part2_verify/0) == expected)
  end
end

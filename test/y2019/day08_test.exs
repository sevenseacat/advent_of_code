defmodule Y2019.Day08Test do
  use ExUnit.Case, async: true
  alias Y2019.Day08
  doctest Day08

  import ExUnit.CaptureIO

  test "verification, part 1", do: assert(Day08.part1_verify() == 2193)

  test "verification, part 2" do
    expected = """
    .XXX.....X.XX.X....X....X
    .XXX..XXXX.XX.X.XXXX.XXXX
    X.X.X...XX....X...XX...XX
    XX.XX.XXXX.XX.X.XXXX.XXXX
    XX.XX.XXXX.XX.X.XXXX.XXXX
    XX.XX....X.XX.X....X.XXXX
    """

    actual = capture_io(fn -> Day08.part2_verify() end)
    assert actual == expected
  end
end

defmodule Y2021.Day13Test do
  use ExUnit.Case, async: true
  alias Y2021.Day13
  doctest Day13

  import ExUnit.CaptureIO

  test "verification, part 1", do: assert(Day13.part1_verify() == 751)

  test "verification, part 2" do
    expected = """
    🁢🁢🁢...🁢🁢..🁢..🁢.🁢🁢🁢..🁢..🁢.🁢....🁢..🁢.🁢...
    🁢..🁢.🁢..🁢.🁢..🁢.🁢..🁢.🁢.🁢..🁢....🁢.🁢..🁢...
    🁢..🁢.🁢....🁢🁢🁢🁢.🁢..🁢.🁢🁢...🁢....🁢🁢...🁢...
    🁢🁢🁢..🁢.🁢🁢.🁢..🁢.🁢🁢🁢..🁢.🁢..🁢....🁢.🁢..🁢...
    🁢....🁢..🁢.🁢..🁢.🁢.🁢..🁢.🁢..🁢....🁢.🁢..🁢...
    🁢.....🁢🁢🁢.🁢..🁢.🁢..🁢.🁢..🁢.🁢🁢🁢🁢.🁢..🁢.🁢🁢🁢🁢
    """

    actual = capture_io(fn -> Day13.part2_verify() end)
    assert actual == expected
  end
end

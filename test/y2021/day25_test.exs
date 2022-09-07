defmodule Y2021.Day25Test do
  use ExUnit.Case, async: true
  alias Y2021.Day25
  doctest Day25

  @tag timeout: :infinity
  test "verification, part 1", do: assert(Day25.part1_verify() == 498)

  test "part1/1" do
    input = """
    v...>>.vv>
    .vv>>.vv..
    >>.>v>...v
    >>v>>.>.v.
    v>v.vv.v..
    >.>>..v...
    .vv..>.>v.
    v.v..>>v.v
    ....v..v.>
    """

    assert Day25.parse_input(input) |> Day25.part1() == 58
  end
end

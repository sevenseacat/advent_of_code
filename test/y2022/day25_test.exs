defmodule Y2022.Day25Test do
  use ExUnit.Case, async: true
  alias Y2022.Day25
  doctest Day25

  test "verification, part 1", do: assert(Day25.part1_verify() == "2-02===-21---2002==0")

  test "part1/1" do
    input = """
    1=-0-2
    12111
    2=0=
    21
    2=01
    111
    20012
    112
    1=-1=
    1-12
    12
    1=
    122
    """

    assert "2=-1=0" == Day25.parse_input(input) |> Day25.part1()
  end
end

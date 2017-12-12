defmodule Y2017.Day08Test do
  use ExUnit.Case, async: true
  alias Y2017.Day08
  doctest Day08

  test "verification, part 1", do: assert(Day08.part1_verify() == 3880)

  test "part 1" do
    input = """
    b inc 5 if a > 1
    a inc 1 if b < 5
    c dec -10 if a >= 1
    c inc -20 if c == 10
    """

    assert Day08.part1(input) == {"a", 1}
  end
end

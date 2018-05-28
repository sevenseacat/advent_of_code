defmodule Y2017.Day25Test do
  use ExUnit.Case, async: true
  alias Y2017.Day25
  doctest Day25

  import Day25, only: [l: 1, r: 1]

  test "verification, part 1", do: assert(Day25.part1_verify() == 5593)

  test "part 1 with the example data" do
    rules = %{A: {{1, &r/1, :B}, {0, &l/1, :B}}, B: {{1, &l/1, :A}, {1, &r/1, :A}}}

    assert Day25.part1(rules, 6) == 3
  end
end

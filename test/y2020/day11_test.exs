defmodule Y2020.Day11Test do
  use ExUnit.Case, async: true
  alias Y2020.Day11
  doctest Day11

  test "verification, part 1", do: assert(Day11.part1_verify() == 2319)

  test "part_1/1" do
    result = test_data("11/initial") |> Day11.parse_input() |> Day11.part1()
    assert result == {37, 5}
  end

  test "run_round/1" do
    initial = test_data("11/initial") |> Day11.parse_input()
    round1 = test_data("11/round1") |> Day11.parse_input()
    round2 = test_data("11/round2") |> Day11.parse_input()
    round3 = test_data("11/round3") |> Day11.parse_input()
    round4 = test_data("11/round4") |> Day11.parse_input()
    round5 = test_data("11/round5") |> Day11.parse_input()

    assert Day11.run_round(initial) == round1
    assert Day11.run_round(round1) == round2
    assert Day11.run_round(round2) == round3
    assert Day11.run_round(round3) == round4
    assert Day11.run_round(round4) == round5
    assert Day11.run_round(round5) == round5
  end

  def test_data(name), do: Day11.input("../../../test/y2020/input/day#{name}")
end

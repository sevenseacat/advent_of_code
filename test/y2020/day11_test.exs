defmodule Y2020.Day11Test do
  use ExUnit.Case, async: true
  alias Y2020.Day11
  doctest Day11

  test "verification, part 1", do: assert(Day11.part1_verify() == 2319)
  test "verification, part 2", do: assert(Day11.part2_verify() == 2117)

  test "part_1/1" do
    result = test_data("11/initial") |> Day11.parse_input() |> Day11.part1()
    assert result == {37, 5}
  end

  test "part_2/1" do
    result = test_data("11/initial") |> Day11.parse_input() |> Day11.part2()
    assert result == {26, 6}
  end

  test "run_round/1 for part 1" do
    initial = test_data("11/initial") |> Day11.parse_input()
    round1 = test_data("11/round1") |> Day11.parse_input()
    round2 = test_data("11/p1_round2") |> Day11.parse_input()
    round3 = test_data("11/p1_round3") |> Day11.parse_input()
    round4 = test_data("11/p1_round4") |> Day11.parse_input()
    round5 = test_data("11/p1_round5") |> Day11.parse_input()

    assert Day11.run_round(initial, 4, &Day11.neighbouring_seats/2) == round1
    assert Day11.run_round(round1, 4, &Day11.neighbouring_seats/2) == round2
    assert Day11.run_round(round2, 4, &Day11.neighbouring_seats/2) == round3
    assert Day11.run_round(round3, 4, &Day11.neighbouring_seats/2) == round4
    assert Day11.run_round(round4, 4, &Day11.neighbouring_seats/2) == round5
    assert Day11.run_round(round5, 4, &Day11.neighbouring_seats/2) == round5
  end

  test "run_round/1 for part 2" do
    initial = test_data("11/initial") |> Day11.parse_input()
    round1 = test_data("11/round1") |> Day11.parse_input()
    round2 = test_data("11/p2_round2") |> Day11.parse_input()
    round3 = test_data("11/p2_round3") |> Day11.parse_input()
    round4 = test_data("11/p2_round4") |> Day11.parse_input()
    round5 = test_data("11/p2_round5") |> Day11.parse_input()
    round6 = test_data("11/p2_round6") |> Day11.parse_input()

    assert Day11.run_round(initial, 5, &Day11.line_of_sight_seats/2) == round1
    assert Day11.run_round(round1, 5, &Day11.line_of_sight_seats/2) == round2
    assert Day11.run_round(round2, 5, &Day11.line_of_sight_seats/2) == round3
    assert Day11.run_round(round3, 5, &Day11.line_of_sight_seats/2) == round4
    assert Day11.run_round(round4, 5, &Day11.line_of_sight_seats/2) == round5
    assert Day11.run_round(round5, 5, &Day11.line_of_sight_seats/2) == round6
    assert Day11.run_round(round6, 5, &Day11.line_of_sight_seats/2) == round6
  end

  def test_data(name), do: Day11.input("../../../test/y2020/input/day#{name}")
end

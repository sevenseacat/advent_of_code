defmodule Y2022.Day16Test do
  use ExUnit.Case, async: true
  alias Y2022.Day16
  doctest Day16

  test "verification, part 1", do: assert(Day16.part1_verify() == 2330)
  test "verification, part 2", do: assert(Day16.part2_verify() == 2675)

  @sample_input """
  Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
  Valve BB has flow rate=13; tunnels lead to valves CC, AA
  Valve CC has flow rate=2; tunnels lead to valves DD, BB
  Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
  Valve EE has flow rate=3; tunnels lead to valves FF, DD
  Valve FF has flow rate=0; tunnels lead to valves EE, GG
  Valve GG has flow rate=0; tunnels lead to valves FF, HH
  Valve HH has flow rate=22; tunnel leads to valve GG
  Valve II has flow rate=0; tunnels lead to valves AA, JJ
  Valve JJ has flow rate=21; tunnel leads to valve II
  """

  test "part1/1" do
    assert 1651 == Day16.parse_input(@sample_input) |> Day16.part1()
  end

  test "part2/1" do
    assert 1707 == Day16.parse_input(@sample_input) |> Day16.part2()
  end
end

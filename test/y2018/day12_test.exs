defmodule Y2018.Day12Test do
  use ExUnit.Case, async: true
  alias Y2018.Day12
  doctest Day12

  test "verification, part 1", do: assert(Day12.part1_verify() == 2140)
  test "verification, part 2", do: assert(Day12.part2_verify() == 1_900_000_000_384)

  test "part 1 works for sample input" do
    initial = "#..#.#..##......###...###"

    rules =
      "...## => #\n..#.. => #\n.#... => #\n.#.#. => #\n.#.## => #\n.##.. => #\n.#### => #\n#.#.# => #\n#.### => #\n##.#. => #\n##.## => #\n###.. => #\n###.# => #\n####. => #"

    assert Day12.part1(initial, rules, 0) == 145

    assert Day12.part1(initial, rules, 1) == 91

    assert Day12.part1(initial, rules, 20) == 325
  end

  test "parsing input" do
    input =
      "...## => #\n..#.. => #\n.#... => #\n.#.#. => #\n.#.## => #\n.##.. => #\n.#### => #\n#.#.# => #\n#.### => #\n##.#. => #\n##.## => #\n###.. => #\n###.# => #\n####. => #"

    output = [
      {[?., ?., ?., ?#, ?#], ?#},
      {[?., ?., ?#, ?., ?.], ?#},
      {[?., ?#, ?., ?., ?.], ?#},
      {[?., ?#, ?., ?#, ?.], ?#},
      {[?., ?#, ?., ?#, ?#], ?#},
      {[?., ?#, ?#, ?., ?.], ?#},
      {[?., ?#, ?#, ?#, ?#], ?#},
      {[?#, ?., ?#, ?., ?#], ?#},
      {[?#, ?., ?#, ?#, ?#], ?#},
      {[?#, ?#, ?., ?#, ?.], ?#},
      {[?#, ?#, ?., ?#, ?#], ?#},
      {[?#, ?#, ?#, ?., ?.], ?#},
      {[?#, ?#, ?#, ?., ?#], ?#},
      {[?#, ?#, ?#, ?#, ?.], ?#}
    ]

    assert Day12.parse_input(input) == output
  end
end

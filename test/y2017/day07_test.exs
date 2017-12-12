defmodule Y2017.Day07Test do
  use ExUnit.Case, async: true
  alias Y2017.Day07
  alias Y2017.Day07.Program
  doctest Day07

  setup_all do
    programs = [
      %Program{name: "pbga", weight: 66, holding: []},
      %Program{name: "xhth", weight: 57, holding: []},
      %Program{name: "ebii", weight: 61, holding: []},
      %Program{name: "havc", weight: 66, holding: []},
      %Program{name: "ktlj", weight: 57, holding: []},
      %Program{name: "fwft", weight: 72, holding: ["ktlj", "cntj", "xhth"]},
      %Program{name: "qoyq", weight: 66, holding: []},
      %Program{name: "padx", weight: 45, holding: ["pbga", "havc", "qoyq"]},
      %Program{name: "tknk", weight: 41, holding: ["ugml", "padx", "fwft"]},
      %Program{name: "jptl", weight: 61, holding: []},
      %Program{name: "ugml", weight: 68, holding: ["gyxo", "ebii", "jptl"]},
      %Program{name: "gyxo", weight: 61, holding: []},
      %Program{name: "cntj", weight: 57, holding: []}
    ]

    [programs: programs]
  end

  test "verification, part 1", do: assert(Day07.part1_verify() == "bsfpjtc")

  test "parsing the input", context do
    test_file = "../../../test/y2017/input/day07"
    assert Day07.input(test_file) |> Day07.parse_input() == context[:programs]
  end

  test "part 1", context do
    assert Day07.part1(context[:programs]) ==
             %Program{name: "tknk", weight: 41, holding: ["ugml", "padx", "fwft"]}
  end
end

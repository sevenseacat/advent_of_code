defmodule Y2023.Day08Test do
  use ExUnit.Case, async: true
  alias Y2023.Day08
  doctest Day08

  test "verification, part 1", do: assert(Day08.part1_verify() == 17287)
  test "verification, part 2", do: assert(Day08.part2_verify() == 18_625_484_023_687)

  @sample_input """
  LLR

  AAA = (BBB, BBB)
  BBB = (AAA, ZZZ)
  ZZZ = (ZZZ, ZZZ)
  """

  test "parse_input/1" do
    expected = %{
      directions: ["L", "L", "R"],
      network: %{
        "AAA" => %{"L" => "BBB", "R" => "BBB"},
        "BBB" => %{"L" => "AAA", "R" => "ZZZ"},
        "ZZZ" => %{"L" => "ZZZ", "R" => "ZZZ"}
      }
    }

    assert expected == Day08.parse_input(@sample_input)
  end

  test "part1" do
    assert 6 == Day08.parse_input(@sample_input) |> Day08.part1()
  end

  test "part2" do
    input = """
    LR

    11A = (11B, XXX)
    11B = (XXX, 11Z)
    11Z = (11B, XXX)
    22A = (22B, XXX)
    22B = (22C, 22C)
    22C = (22Z, 22Z)
    22Z = (22B, 22B)
    XXX = (XXX, XXX)
    """

    assert 6 == Day08.parse_input(input) |> Day08.part2()
  end
end

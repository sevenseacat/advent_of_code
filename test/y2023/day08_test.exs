defmodule Y2023.Day08Test do
  use ExUnit.Case, async: true
  alias Y2023.Day08
  doctest Day08

  test "verification, part 1", do: assert(Day08.part1_verify() == 17287)
  # test "verification, part 2", do: assert(Day08.part2_verify() == "update or delete me")

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
    actual = Day08.parse_input(@sample_input) |> Day08.part1()
    assert actual == ["AAA", "BBB", "AAA", "BBB", "AAA", "BBB"]
  end
end

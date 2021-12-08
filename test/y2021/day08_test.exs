defmodule Y2021.Day08Test do
  use ExUnit.Case, async: true
  alias Y2021.Day08
  doctest Day08

  @parsed_entry %{
    signals: [
      "abcdefg",
      "bcdef",
      "acdfg",
      "abcdf",
      "abd",
      "abcdef",
      "bcdefg",
      "abef",
      "abcdeg",
      "ab"
    ],
    outputs: ["bcdef", "abcdf", "bcdef", "abcdf"]
  }

  test "verification, part 1", do: assert(Day08.part1_verify() == 504)

  test "parse_input/1" do
    result =
      Day08.parse_input(
        "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
      )

    assert result == [@parsed_entry]
  end

  test "part1/1" do
    result =
      "../../../test/y2021/input/day08" |> Day08.input() |> Day08.parse_input() |> Day08.part1()

    assert result == 26
  end

  test "find_output_value/1" do
    parsed_entry = %{
      outputs: ["abcdefg", "abce", "ac", "abcdefg"],
      signals: [
        "abefg",
        "ac",
        "abcefg",
        "abcdefg",
        "acdefg",
        "bcdfg",
        "abce",
        "abdefg",
        "abcfg",
        "acf"
      ]
    }

    result = Day08.find_output_value(parsed_entry)
    assert result == [8, 4, 1, 8]
  end

  test "find_digits/1" do
    result = Map.get(@parsed_entry, :signals) |> Day08.find_digits()
    assert Map.get(result, "ab") == 1
    assert Map.get(result, "abd") == 7
    assert Map.get(result, "abef") == 4
    assert Map.get(result, "abcdefg") == 8
  end
end

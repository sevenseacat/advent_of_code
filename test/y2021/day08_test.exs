defmodule Y2021.Day08Test do
  use ExUnit.Case, async: true
  alias Y2021.Day08
  doctest Day08

  @test_file "../../../test/y2021/input/day08"

  test "verification, part 1", do: assert(Day08.part1_verify() == 504)
  test "verification, part 2", do: assert(Day08.part2_verify() == 1_073_431)

  test "parse_input/1" do
    result =
      Day08.parse_input(
        "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
      )

    assert result == [
             %{
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
           ]
  end

  test "part1/1" do
    result = Day08.input(@test_file) |> Day08.parse_input() |> Day08.part1()
    assert result == 26
  end

  test "part2/1" do
    result = Day08.input(@test_file) |> Day08.parse_input() |> Day08.part2()
    assert result == 61229
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
    result =
      Day08.find_digits([
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
      ])

    # Part 1
    assert Map.get(result, "ab") == 1
    assert Map.get(result, "abd") == 7
    assert Map.get(result, "abef") == 4
    assert Map.get(result, "abcdefg") == 8

    # Part 2
    assert Map.get(result, "abcdef") == 9
    assert Map.get(result, "abcdf") == 3
    assert Map.get(result, "abcdeg") == 0
    assert Map.get(result, "bcdefg") == 6
    assert Map.get(result, "bcdef") == 5
    assert Map.get(result, "acdfg") == 2
  end
end

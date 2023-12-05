defmodule Y2023.Day05Test do
  use ExUnit.Case, async: true
  alias Y2023.Day05
  doctest Day05

  test "verification, part 1", do: assert(Day05.part1_verify() == 551_761_867)

  @tag timeout: :infinity
  test "verification, part 2", do: assert(Day05.part2_verify() == 57_451_709)

  @sample_input """
  seeds: 79 14 55 13

  seed-to-soil map:
  50 98 2
  52 50 48

  soil-to-fertilizer map:
  0 15 37
  37 52 2
  39 0 15

  fertilizer-to-water map:
  49 53 8
  0 11 42
  42 0 7
  57 7 4

  water-to-light map:
  88 18 7
  18 25 70

  light-to-temperature map:
  45 77 23
  81 45 19
  68 64 13

  temperature-to-humidity map:
  0 69 1
  1 0 69

  humidity-to-location map:
  60 56 37
  56 93 4
  """

  test "part 1" do
    actual = @sample_input |> Day05.parse_input() |> Day05.part1()

    expected = [
      %{
        seed: 79,
        soil: 81,
        fertilizer: 81,
        water: 81,
        light: 74,
        temperature: 78,
        humidity: 78,
        location: 82
      },
      %{
        seed: 14,
        soil: 14,
        fertilizer: 53,
        water: 49,
        light: 42,
        temperature: 42,
        humidity: 43,
        location: 43
      },
      %{
        seed: 55,
        soil: 57,
        fertilizer: 57,
        water: 53,
        light: 46,
        temperature: 82,
        humidity: 82,
        location: 86
      },
      %{
        seed: 13,
        soil: 13,
        fertilizer: 52,
        water: 41,
        light: 34,
        temperature: 34,
        humidity: 35,
        location: 35
      }
    ]

    assert Enum.sort(actual) == Enum.sort(expected)
  end

  test "part 2" do
    actual = @sample_input |> Day05.parse_input() |> Day05.part2()
    assert actual == 46
  end

  test "parse_input" do
    actual = Day05.parse_input(@sample_input)

    expected = %{
      seeds: [79, 14, 55, 13],
      soil: [
        %{destination: 50, source: 98, size: 2},
        %{destination: 52, source: 50, size: 48}
      ],
      fertilizer: [
        %{destination: 0, source: 15, size: 37},
        %{destination: 37, source: 52, size: 2},
        %{destination: 39, source: 0, size: 15}
      ],
      water: [
        %{destination: 49, source: 53, size: 8},
        %{destination: 0, source: 11, size: 42},
        %{destination: 42, source: 0, size: 7},
        %{destination: 57, source: 7, size: 4}
      ],
      light: [
        %{destination: 88, source: 18, size: 7},
        %{destination: 18, source: 25, size: 70}
      ],
      temperature: [
        %{destination: 45, source: 77, size: 23},
        %{destination: 81, source: 45, size: 19},
        %{destination: 68, source: 64, size: 13}
      ],
      humidity: [
        %{destination: 0, source: 69, size: 1},
        %{destination: 1, source: 0, size: 69}
      ],
      location: [
        %{destination: 60, source: 56, size: 37},
        %{destination: 56, source: 93, size: 4}
      ]
    }

    assert actual == expected
  end
end

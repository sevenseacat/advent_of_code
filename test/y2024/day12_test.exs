defmodule Y2024.Day12Test do
  use ExUnit.Case, async: true
  alias Y2024.Day12
  doctest Day12

  @sample1 """
  AAAA
  BBCD
  BBCC
  EEEC
  """

  @sample2 """
  OOOOO
  OXOXO
  OOOOO
  OXOXO
  OOOOO
  """

  @sample3 """
  RRRRIICCFF
  RRRRIICCCF
  VVRRRCCFFF
  VVRCCCJFFF
  VVVVCJJCFE
  VVIVCCJJEE
  VVIIICJJEE
  MIIIIIJJEE
  MIIISIJEEE
  MMMISSJEEE
  """

  @sample4 """
  EEEEE
  EXXXX
  EEEEE
  EXXXX
  EEEEE
  """

  test "part1/1" do
    expected1 = %{
      "A" => [%{area: 4, border: 10}],
      "B" => [%{area: 4, border: 8}],
      "C" => [%{area: 4, border: 10}],
      "D" => [%{area: 1, border: 4}],
      "E" => [%{area: 3, border: 8}]
    }

    expected2 = %{
      "X" => [
        %{area: 1, border: 4},
        %{area: 1, border: 4},
        %{area: 1, border: 4},
        %{area: 1, border: 4}
      ],
      "O" => [
        %{area: 21, border: 36}
      ]
    }

    expected3 = %{
      "R" => [%{area: 12, border: 18}],
      "I" => [%{area: 4, border: 8}, %{area: 14, border: 22}],
      "C" => [%{area: 1, border: 4}, %{area: 14, border: 28}],
      "F" => [%{area: 10, border: 18}],
      "V" => [%{area: 13, border: 20}],
      "J" => [%{area: 11, border: 20}],
      "E" => [%{area: 13, border: 18}],
      "M" => [%{area: 5, border: 12}],
      "S" => [%{area: 3, border: 8}]
    }

    assert Day12.parse_input(@sample1) |> Day12.part1() == expected1
    assert Day12.parse_input(@sample2) |> Day12.part1() == expected2
    assert Day12.parse_input(@sample3) |> Day12.part1() == expected3
  end

  test "part2/2" do
    expected1 = %{
      "A" => [%{area: 4, sides: 4}],
      "B" => [%{area: 4, sides: 4}],
      "C" => [%{area: 4, sides: 8}],
      "D" => [%{area: 1, sides: 4}],
      "E" => [%{area: 3, sides: 4}]
    }

    expected4 = %{
      "X" => [
        %{area: 4, sides: 4},
        %{area: 4, sides: 4}
      ],
      "E" => [
        %{area: 17, sides: 12}
      ]
    }

    assert Day12.parse_input(@sample1) |> Day12.part2() == expected1
    assert Day12.parse_input(@sample4) |> Day12.part2() == expected4
  end

  test "verification, part 1", do: assert(Day12.part1_verify() == 1_375_476)
  test "verification, part 2", do: assert(Day12.part2_verify() == 821_372)
end

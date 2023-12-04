defmodule Y2020.Day20Test do
  use ExUnit.Case, async: true
  alias Y2020.Day20
  doctest Day20

  test "verification, part 1", do: assert(Day20.part1_verify() == "update or delete me")
  # test "verification, part 2", do: assert(Day20.part2_verify() == "update or delete me")

  test "part1/1" do
    input = test_data("20/sample")

    corners = input |> Day20.parse_input() |> Day20.part1()
    assert Enum.sort(corners) == [1171, 1951, 2971, 3079]
  end

  test "parse_input/1" do
    input = test_data("20/small")

    expected = [
      %Day20.Tile{
        number: 1951,
        version: nil,
        versions: [
          %Day20.TileVersion{
            content: [["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"]],
            left_edge: ["1", "4", "7"],
            right_edge: ["3", "6", "9"],
            top_edge: ["1", "2", "3"],
            bottom_edge: ["7", "8", "9"]
          },
          %Day20.TileVersion{
            content: [["7", "4", "1"], ["8", "5", "2"], ["9", "6", "3"]],
            left_edge: ["7", "8", "9"],
            right_edge: ["1", "2", "3"],
            top_edge: ["7", "4", "1"],
            bottom_edge: ["9", "6", "3"]
          },
          %Day20.TileVersion{
            content: [["9", "8", "7"], ["6", "5", "4"], ["3", "2", "1"]],
            left_edge: ["9", "6", "3"],
            right_edge: ["7", "4", "1"],
            top_edge: ["9", "8", "7"],
            bottom_edge: ["3", "2", "1"]
          },
          %Day20.TileVersion{
            content: [["3", "6", "9"], ["2", "5", "8"], ["1", "4", "7"]],
            left_edge: ["3", "2", "1"],
            right_edge: ["9", "8", "7"],
            top_edge: ["3", "6", "9"],
            bottom_edge: ["1", "4", "7"]
          },
          %Day20.TileVersion{
            content: [["3", "2", "1"], ["6", "5", "4"], ["9", "8", "7"]],
            left_edge: ["3", "6", "9"],
            right_edge: ["1", "4", "7"],
            top_edge: ["3", "2", "1"],
            bottom_edge: ["9", "8", "7"]
          },
          %Day20.TileVersion{
            content: [["9", "6", "3"], ["8", "5", "2"], ["7", "4", "1"]],
            left_edge: ["9", "8", "7"],
            right_edge: ["3", "2", "1"],
            top_edge: ["9", "6", "3"],
            bottom_edge: ["7", "4", "1"]
          },
          %Day20.TileVersion{
            content: [["7", "8", "9"], ["4", "5", "6"], ["1", "2", "3"]],
            left_edge: ["7", "4", "1"],
            right_edge: ["9", "6", "3"],
            top_edge: ["7", "8", "9"],
            bottom_edge: ["1", "2", "3"]
          },
          %Day20.TileVersion{
            content: [["1", "4", "7"], ["2", "5", "8"], ["3", "6", "9"]],
            left_edge: ["1", "2", "3"],
            right_edge: ["7", "8", "9"],
            top_edge: ["1", "4", "7"],
            bottom_edge: ["3", "6", "9"]
          }
        ]
      }
    ]

    assert expected == Day20.parse_input(input)
  end

  def test_data(name), do: Day20.input("../../../test/y2020/input/day#{name}")
end

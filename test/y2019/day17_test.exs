defmodule Y2019.Day17Test do
  use ExUnit.Case, async: true
  alias Y2019.Day17
  doctest Day17

  test "verification, part 1", do: assert(Day17.part1_verify() == 5788)
  test "verification, part 2", do: assert(Day17.part2_verify() == 648_545)

  test "part1/1" do
    input = """
    ..#..........
    ..#..........
    #######...###
    #.#...#...#.#
    #############
    ..#...#...#..
    ..#####...^..
    """

    assert 76 == Day17.part1(input)
  end

  test "find_path/3" do
    output = [
      :right,
      8,
      :right,
      8,
      :right,
      4,
      :right,
      4,
      :right,
      8,
      :left,
      6,
      :left,
      2,
      :right,
      4,
      :right,
      4,
      :right,
      8,
      :right,
      8,
      :right,
      8,
      :left,
      6,
      :left,
      2
    ]

    assert output == Day17.to_grid(sample_input()) |> Day17.find_path()
  end

  def sample_input do
    """
    #######...#####
    #.....#...#...#
    #.....#...#...#
    ......#...#...#
    ......#...###.#
    ......#.....#.#
    ^########...#.#
    ......#.#...#.#
    ......#########
    ........#...#..
    ....#########..
    ....#...#......
    ....#...#......
    ....#...#......
    ....#####......
    """
  end
end

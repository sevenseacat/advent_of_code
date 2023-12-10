defmodule Y2023.Day10Test do
  use ExUnit.Case, async: true
  alias Y2023.Day10
  doctest Day10

  test "verification, part 1", do: assert(Day10.part1_verify() == 7030)
  test "verification, part 2", do: assert(Day10.part2_verify() == 285)

  test "part 1" do
    sample_1 = """
    -L|F7
    7S-7|
    L|7||
    -L-J|
    L|-JF
    """

    assert 4 == Day10.parse_input(sample_1) |> Day10.part1()

    sample_2 = """
    7-F7-
    .FJ|7
    SJLL7
    |F--J
    LJ.LJ
    """

    assert 8 == Day10.parse_input(sample_2) |> Day10.part1()
  end

  describe "part 2" do
    test "sample 1" do
      input = """
      ...........
      .S-------7.
      .|F-----7|.
      .||.....||.
      .||.....||.
      .|L-7.F-J|.
      .|..|.|..|.
      .L--J.L--J.
      ...........
      """

      assert 4 == Day10.parse_input(input) |> Day10.part2()
    end

    test "sample 2" do
      input = """
      .F----7F7F7F7F-7....
      .|F--7||||||||FJ....
      .||.FJ||||||||L7....
      FJL7L7LJLJ||LJ.L-7..
      L--J.L7...LJS7F-7L7.
      ....F-J..F7FJ|L7L7L7
      ....L7.F7||L7|.L7L7|
      .....|FJLJ|FJ|F7|.LJ
      ....FJL-7.||.||||...
      ....L---J.LJ.LJLJ...
      """

      assert 8 == Day10.parse_input(input) |> Day10.part2()
    end

    test "sample 3" do
      input = """
      FF7FSF7F7F7F7F7F---7
      L|LJ||||||||||||F--J
      FL-7LJLJ||||||LJL-77
      F--JF--7||LJLJ7F7FJ-
      L---JF-JLJ.||-FJLJJ7
      |F|F-JF---7F7-L7L|7|
      |FFJF7L7F-JF7|JL---7
      7-L-JL7||F7|L7F-7F7|
      L.L7LFJ|||||FJL7||LJ
      L7JLJL-JLJLJL--JLJ.L
      """

      assert 10 == Day10.parse_input(input) |> Day10.part2()
    end
  end
end

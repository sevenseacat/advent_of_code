defmodule Y2019.Day18Test do
  use ExUnit.Case, async: true
  alias Y2019.Day18
  doctest Day18

  @tag :skip
  test "verification, part 1", do: assert(Day18.part1_verify() == 7430)

  # test "verification, part 2", do: assert(Day18.part2_verify() == "update or delete me")

  describe "part1/1" do
    test "small input" do
      input = """
      #########
      #b.A.@.a#
      #########
      """

      result = Day18.parse_input(input) |> Day18.part1()
      assert result == 8
    end

    test "input 2" do
      input = """
      ########################
      #f.D.E.e.C.b.A.@.a.B.c.#
      ######################.#
      #d.....................#
      ########################
      """

      result = Day18.parse_input(input) |> Day18.part1()
      assert result == 86
    end

    test "input 3" do
      input = """
      ########################
      #...............b.C.D.f#
      #.######################
      #.....@.a.B.c.d.A.e.F.g#
      ########################
      """

      result = Day18.parse_input(input) |> Day18.part1()
      assert result == 132
    end

    @tag timeout: :infinity
    test "input 4" do
      input = """
      #################
      #i.G..c...e..H.p#
      ########.########
      #j.A..b...f..D.o#
      ########@########
      #k.E..a...g..B.n#
      ########.########
      #l.F..d...h..C.m#
      #################
      """

      result = Day18.parse_input(input) |> Day18.part1()
      assert result == 136
    end

    test "input 5" do
      input = """
      ########################
      #@..............ac.GI.b#
      ###d#e#f################
      ###A#B#C################
      ###g#h#i################
      ########################
      """

      result = Day18.parse_input(input) |> Day18.part1()
      assert result == 81
    end
  end
end

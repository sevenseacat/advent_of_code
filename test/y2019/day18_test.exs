defmodule Y2019.Day18Test do
  use ExUnit.Case, async: true
  alias Y2019.Day18
  doctest Day18

  @tag :skip
  test "verification, part 1", do: assert(Day18.part1_verify() == 7430)

  # test "verification, part 2", do: assert(Day18.part2_verify() == "update or delete me")

  describe "parts/1 - multiple start points" do
    test "small input" do
      input = """
      #######
      #a.#Cd#
      ##@#@##
      #######
      ##@#@##
      #cB#.b#
      #######
      """

      assert_answer(input, 8)
    end

    test "input 2" do
      input = """
      ###############
      #d.ABC.#.....a#
      ######@#@######
      ###############
      ######@#@######
      #b.....#.....c#
      ###############
      """

      assert_answer(input, 24)
    end

    test "input 3" do
      input = """
      #############
      #DcBa.#.GhKl#
      #.###@#@#I###
      #e#d#####j#k#
      ###C#@#@###J#
      #fEbA.#.FgHi#
      #############
      """

      assert_answer(input, 32)
    end

    test "input 4" do
      input = """
      #############
      #g#f.D#..h#l#
      #F###e#E###.#
      #dCba@#@BcIJ#
      #############
      #nK.L@#@G...#
      #M###N#H###.#
      #o#m..#i#jk.#
      #############
      """

      assert_answer(input, 72)
    end
  end

  describe "parts/1 - single start point" do
    test "small input" do
      input = """
      #########
      #b.A.@.a#
      #########
      """

      assert_answer(input, 8)
    end

    test "input 2" do
      input = """
      ########################
      #f.D.E.e.C.b.A.@.a.B.c.#
      ######################.#
      #d.....................#
      ########################
      """

      assert_answer(input, 86)
    end

    test "input 3" do
      input = """
      ########################
      #...............b.C.D.f#
      #.######################
      #.....@.a.B.c.d.A.e.F.g#
      ########################
      """

      assert_answer(input, 132)
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

      assert_answer(input, 136)
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

      assert_answer(input, 81)
    end
  end

  def assert_answer(input, answer) do
    assert answer == Day18.parse_input(input) |> Day18.parts()
  end
end

defmodule Y2016.Day21Test do
  use ExUnit.Case, async: true
  alias Y2016.Day21
  doctest Day21

  test "verification, part 1", do: assert(Day21.part1_verify() == "agcebfdh")

  test "parse_input/1" do
    input = """
    swap position 4 with position 0
    swap letter d with letter b
    rotate left 1 step
    rotate right 3 steps
    move position 3 to position 0
    rotate based on position of letter b
    reverse positions 1 through 2
    """

    assert Day21.parse_input(input) == [
             {:swap_position, 4, 0},
             {:swap_letter, "d", "b"},
             {:rotate_left, 1},
             {:rotate_right, 3},
             {:move_position, 3, 0},
             {:rotate_position, "b"},
             {:reverse, 1, 2}
           ]
  end

  describe "part1/1" do
    test "full sample" do
      cmds =
        Day21.parse_input("""
        swap position 4 with position 0
        swap letter d with letter b
        reverse positions 0 through 4
        rotate left 1 step
        move position 1 to position 4
        move position 3 to position 0
        rotate based on position of letter b
        rotate based on position of letter d
        """)

      assert Day21.part1(cmds, "abcde") == "decab"
    end

    test "swap command" do
      assert Day21.part1([{:swap_position, 4, 0}], "abcde") == "ebcda"
    end

    test "reverse command" do
      assert Day21.part1([{:reverse, 2, 3}], "ebcda") == "ebdca"
    end

    test "rotate left command" do
      assert Day21.part1([{:rotate_left, 1}], "arstd") == "rstda"
    end

    test "rotate right command" do
      assert Day21.part1([{:rotate_right, 2}], "arstd") == "tdars"
    end

    test "move position command" do
      assert Day21.part1([{:move_position, 1, 3}], "hneio") == "heino"
    end

    test "rotate position command" do
      # position 2 + 1
      assert Day21.part1([{:rotate_position, "s"}], "arstdhneio") == "eioarstdhn"

      # position 4 + 2
      assert Day21.part1([{:rotate_position, "d"}], "arstdhneio") == "dhneioarst"

      # position 4 + 2
      assert Day21.part1([{:rotate_position, "d"}], "arstd") == "darst"
    end
  end
end

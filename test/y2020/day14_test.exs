defmodule Y2020.Day14Test do
  use ExUnit.Case, async: true
  alias Y2020.Day14
  doctest Day14

  test "verification, part 1", do: assert(Day14.part1_verify() == 14_839_536_808_842)

  test "parse_input/1" do
    input = """
    mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
    mem[8] = 11
    mem[7] = 101
    mem[8] = 0
    mask = XXX1X0X1XXXXXXXXXXXXXXXXXXXXX1XXXX0X
    mem[8] = 12
    mem[7] = 181
    mem[8] = 99
    """

    output = [
      {
        %{29 => 1, 34 => 0},
        [%{position: 8, value: 11}, %{position: 7, value: 101}, %{position: 8, value: 0}]
      },
      {
        %{3 => 1, 5 => 0, 7 => 1, 29 => 1, 34 => 0},
        [%{position: 8, value: 12}, %{position: 7, value: 181}, %{position: 8, value: 99}]
      }
    ]

    assert Day14.parse_input(input) == output
  end

  test "part1/1" do
    input = [
      {
        %{29 => 1, 34 => 0},
        [%{position: 8, value: 11}, %{position: 7, value: 101}, %{position: 8, value: 0}]
      }
    ]

    output = {%{7 => 101, 8 => 64}, 165}
    assert Day14.part1(input) == output
  end

  test "part2/1" do
    input =
      Day14.parse_input("""
      mask = 000000000000000000000000000000X1001X
      mem[42] = 100
      mask = 00000000000000000000000000000000X0XX
      mem[26] = 1
      """)

    output =
      {%{
         16 => 1,
         17 => 1,
         18 => 1,
         19 => 1,
         24 => 1,
         25 => 1,
         26 => 1,
         27 => 1,
         58 => 100,
         59 => 100
       }, 208}

    assert Day14.part2(input) == output
  end

  test "apply_v1_bitmask/2" do
    bitmask = %{29 => 1, 34 => 0}

    assert 73 == Day14.apply_v1_bitmask(bitmask, 11)
    assert 101 == Day14.apply_v1_bitmask(bitmask, 101)
    assert 64 == Day14.apply_v1_bitmask(bitmask, 0)
  end

  test "apply_v2_bitmask/2" do
    bitmask = Day14.parse_mask("mask = 000000000000000000000000000000X1001X")
    assert [26, 27, 58, 59] = Day14.apply_v2_bitmask(bitmask, 42) |> Enum.sort()

    bitmask = Day14.parse_mask("mask = 00000000000000000000000000000000X0XX")
    assert [16, 17, 18, 19, 24, 25, 26, 27] = Day14.apply_v2_bitmask(bitmask, 26) |> Enum.sort()
  end
end

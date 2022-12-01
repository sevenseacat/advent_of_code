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

  test "apply_bitmask/2" do
    bitmask = %{29 => 1, 34 => 0}

    assert 73 == Day14.apply_bitmask(bitmask, 11)
    assert 101 == Day14.apply_bitmask(bitmask, 101)
    assert 64 == Day14.apply_bitmask(bitmask, 0)
  end
end

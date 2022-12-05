defmodule Y2022.Day05Test do
  use ExUnit.Case, async: true
  alias Y2022.Day05
  doctest Day05

  test "verification, part 1", do: assert(Day05.part1_verify() == 'TLNGFGMFN')
  test "verification, part 2", do: assert(Day05.part2_verify() == 'FGLQJCMBD')

  #     [D]
  # [N] [C]
  # [Z] [M] [P]
  #  1   2   3
  @stacks %{1 => 'ZN', 2 => 'MCD', 3 => 'P'}
  @input Day05.parse_input("""
         move 1 from 2 to 1
         move 3 from 1 to 3
         move 2 from 2 to 1
         move 1 from 1 to 2
         """)

  test "part1/2" do
    result = Day05.part1(@input, @stacks)
    assert result == {%{1 => 'C', 2 => 'M', 3 => 'PDNZ'}, 'CMZ'}
  end

  test "part2/2" do
    result = Day05.part2(@input, @stacks)
    assert result == {%{1 => 'M', 2 => 'C', 3 => 'PZND'}, 'MCD'}
  end
end

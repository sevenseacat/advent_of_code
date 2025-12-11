defmodule Y2025.Day11Test do
  use ExUnit.Case, async: true
  alias Y2025.Day11
  doctest Day11

  test "verification, part 1", do: assert(Day11.part1_verify() == 788)
  # test "verification, part 2", do: assert(Day11.part2_verify() == "update or delete me")

  @sample """
  aaa: you hhh
  you: bbb ccc
  bbb: ddd eee
  ccc: ddd eee fff
  ddd: ggg
  eee: out
  fff: out
  ggg: out
  hhh: ccc fff iii
  iii: out
  """

  test "parse_input" do
    answer = Day11.parse_input(@sample)

    assert answer == %{
             "aaa" => ["you", "hhh"],
             "you" => ["bbb", "ccc"],
             "bbb" => ["ddd", "eee"],
             "ccc" => ["ddd", "eee", "fff"],
             "ddd" => ["ggg"],
             "eee" => ["out"],
             "fff" => ["out"],
             "ggg" => ["out"],
             "hhh" => ["ccc", "fff", "iii"],
             "iii" => ["out"]
           }
  end

  test "part1" do
    answer = @sample |> Day11.parse_input() |> Day11.part1()
    assert answer == 5
  end
end

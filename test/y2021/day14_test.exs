defmodule Y2021.Day14Test do
  use ExUnit.Case, async: true
  alias Y2021.Day14
  doctest Day14

  test "verification, part 1", do: assert(Day14.part1_verify() == 2988)
  test "verification, part 2", do: assert(Day14.part2_verify() == 3_572_761_917_024)

  @rules %{
    "CH" => "B",
    "HH" => "N",
    "CB" => "H",
    "NH" => "C",
    "HB" => "C",
    "HC" => "B",
    "HN" => "C",
    "NN" => "C",
    "BH" => "H",
    "NC" => "B",
    "NB" => "B",
    "BN" => "B",
    "BB" => "N",
    "BC" => "B",
    "CC" => "N",
    "CN" => "C"
  }

  test "parts/2" do
    assert Day14.parts({"NNCB", @rules}, 10) == 1588
    assert Day14.parts({"NNCB", @rules}, 40) == 2_188_189_693_529
  end

  test "parse_input/1" do
    actual =
      Day14.parse_input(
        "NNCB\n\nCH -> B\nHH -> N\nCB -> H\nNH -> C\nHB -> C\nHC -> B\nHN -> C\nNN -> C\nBH -> H\nNC -> B\nNB -> B\nBN -> B\nBB -> N\nBC -> B\nCC -> N\nCN -> C\n"
      )

    assert actual == {"NNCB", @rules}
  end
end

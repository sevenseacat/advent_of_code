defmodule Y2021.Day14Test do
  use ExUnit.Case, async: true
  alias Y2021.Day14
  doctest Day14

  test "verification, part 1", do: assert(Day14.part1_verify() == 2988)

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

  test "part1/2" do
    assert Day14.part1({"NNCB", @rules}, 10) == 1588
  end

  test "pair_insertion/2" do
    input = String.graphemes("NNCB")
    assert Day14.pair_insertion(input, @rules, 1) == String.graphemes("NCNBCHB")
    assert Day14.pair_insertion(input, @rules, 2) == String.graphemes("NBCCNBBBCBHCB")

    assert Day14.pair_insertion(input, @rules, 3) ==
             String.graphemes("NBBBCNCCNBBNBNBBCHBHHBCHB")

    assert Day14.pair_insertion(input, @rules, 4) ==
             String.graphemes("NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB")
  end

  test "parse_input/1" do
    actual =
      Day14.parse_input(
        "NNCB\n\nCH -> B\nHH -> N\nCB -> H\nNH -> C\nHB -> C\nHC -> B\nHN -> C\nNN -> C\nBH -> H\nNC -> B\nNB -> B\nBN -> B\nBB -> N\nBC -> B\nCC -> N\nCN -> C\n"
      )

    assert actual == {"NNCB", @rules}
  end
end

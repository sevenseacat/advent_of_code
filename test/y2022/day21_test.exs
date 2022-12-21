defmodule Y2022.Day21Test do
  use ExUnit.Case, async: true
  alias Y2022.Day21
  doctest Day21

  test "verification, part 1", do: assert(Day21.part1_verify() == 49_288_254_556_480)
  # test "verification, part 2", do: assert(Day21.part2_verify() == "update or delete me")

  @sample_input """
  root: pppw + sjmn
  dbpl: 5
  cczh: sllz + lgvd
  zczc: 2
  ptdq: humn - dvpt
  dvpt: 3
  lfqf: 4
  humn: 5
  ljgn: 2
  sjmn: drzm * dbpl
  sllz: 4
  pppw: cczh / lfqf
  lgvd: ljgn * ptdq
  drzm: hmdt - zczc
  hmdt: 32
  """

  test "part1/1" do
    assert 152 == Day21.parse_input(@sample_input) |> Day21.part1()
  end

  test "parse_input/1" do
    input = """
    pppw: cczh / lfqf
    lgvd: ljgn * ptdq
    hmdt: 32
    """

    expected = %{
      "pppw" => ["cczh", "/", "lfqf"],
      "lgvd" => ["ljgn", "*", "ptdq"],
      "hmdt" => 32
    }

    assert expected == Day21.parse_input(input)
  end
end

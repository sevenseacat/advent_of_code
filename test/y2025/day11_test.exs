defmodule Y2025.Day11Test do
  use ExUnit.Case, async: true
  alias Y2025.Day11
  doctest Day11

  test "verification, part 1", do: assert(Day11.part1_verify() == 788)
  test "verification, part 2", do: assert(Day11.part2_verify() == 316_291_887_968_000)

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

  test "part2" do
    sample = """
    svr: aaa bbb
    aaa: fft
    fft: ccc
    bbb: tty
    tty: ccc
    ccc: ddd eee
    ddd: hub
    hub: fff
    eee: dac
    dac: fff
    fff: ggg hhh
    ggg: out
    hhh: out
    """

    answer = sample |> Day11.parse_input() |> Day11.part2()
    assert answer == 2
  end

  test "count_paths_between" do
    graph = Day11.input() |> Day11.parse_input() |> Day11.build_graph()

    assert Day11.count_paths_between({"dac", "out"}, graph) == 3875
    assert Day11.count_paths_between({"svr", "fft"}, graph) == 10304
    assert Day11.count_paths_between({"fft", "dac"}, graph) == 7_921_556
  end
end

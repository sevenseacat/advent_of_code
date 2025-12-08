defmodule Y2025.Day08Test do
  use ExUnit.Case, async: true
  alias Y2025.Day08
  doctest Day08

  @tag timeout: :infinity
  test "verification, part 1", do: assert(Day08.part1_verify() == 57564)

  @tag timeout: :infinity
  test "verification, part 2", do: assert(Day08.part2_verify() == 133_296_744)

  @sample """
  162,817,812
  57,618,57
  906,360,560
  592,479,940
  352,342,300
  466,668,158
  542,29,236
  431,825,988
  739,650,466
  52,470,668
  216,146,977
  819,987,18
  117,168,530
  805,96,715
  346,949,466
  970,615,88
  941,993,340
  862,61,35
  984,92,344
  425,690,689
  """

  test "part 1" do
    answer = @sample |> Day08.parse_input() |> Day08.part1()
    assert answer == 40
  end

  test "part 2" do
    answer = @sample |> Day08.parse_input() |> Day08.part2()
    assert answer == 25272
  end
end

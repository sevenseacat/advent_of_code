defmodule Y2024.Day23Test do
  use ExUnit.Case, async: true
  alias Y2024.Day23
  doctest Day23

  test "verification, part 1", do: assert(Day23.part1_verify() == 893)

  test "verification, part 2" do
    assert Day23.part2_verify() == "cw,dy,ef,iw,ji,jv,ka,ob,qv,ry,ua,wt,xz"
  end

  @sample """
  kh-tc
  qp-kh
  de-cg
  ka-co
  yn-aq
  qp-ub
  cg-tb
  vc-aq
  tb-ka
  wh-tc
  yn-cg
  kh-ub
  ta-co
  de-co
  tc-td
  tb-wq
  wh-td
  ta-ka
  td-qp
  aq-cg
  wq-ub
  ub-vc
  de-ta
  wq-aq
  wq-vc
  wh-yn
  ka-de
  kh-ta
  co-tc
  wh-qp
  tb-vc
  td-yn
  """

  test "part1" do
    assert Day23.parse_input(@sample) |> Day23.part1() == 7
  end

  test "part2" do
    assert Day23.parse_input(@sample) |> Day23.part2() == "co,de,ka,ta"
  end
end

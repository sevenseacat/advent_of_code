defmodule Y2023.Day19Test do
  use ExUnit.Case, async: true
  alias Y2023.Day19
  doctest Day19

  test "verification, part 1", do: assert(Day19.part1_verify() == 280_909)
  # test "verification, part 2", do: assert(Day19.part2_verify() == "update or delete me")

  @sample_input """
  px{a<2006:qkq,m>2090:A,rfg}
  pv{a>1716:R,A}
  lnx{m>1548:A,A}
  rfg{s<537:gd,x>2440:R,A}
  qs{s>3448:A,lnx}
  qkq{x<1416:A,crn}
  crn{x>2662:A,R}
  in{s<1351:px,qqz}
  qqz{s>2770:qs,m<1801:hdj,R}
  gd{a>3333:R,R}
  hdj{m>838:A,pv}

  {x=787,m=2655,a=1222,s=2876}
  {x=1679,m=44,a=2067,s=496}
  {x=2036,m=264,a=79,s=2244}
  {x=2461,m=1339,a=466,s=291}
  {x=2127,m=1623,a=2188,s=1013}
  """

  test "part 1" do
    actual = Day19.parse_input(@sample_input) |> Day19.part1()
    assert actual == 19114
  end

  test "parse_input" do
    {workflows, parts} = Day19.parse_input(@sample_input)

    assert is_map(workflows)
    assert Map.fetch!(workflows, "px") == [{"a", :lt, 2006, "qkq"}, {"m", :gt, 2090, "A"}, "rfg"]

    assert is_list(parts)
    assert hd(parts) == %{"x" => 787, "m" => 2655, "a" => 1222, "s" => 2876}
  end
end

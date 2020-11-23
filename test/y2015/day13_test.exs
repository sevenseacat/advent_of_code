defmodule Y2015.Day13Test do
  use ExUnit.Case, async: true
  alias Y2015.Day13
  doctest Day13

  test "verification, part 1", do: assert(Day13.part1_verify() == 709)

  test "can parse input" do
    input = "Alice would gain 54 happiness units by sitting next to Bob.
Alice would lose 79 happiness units by sitting next to Carol."
    output = [{"Alice", "Bob", 54}, {"Alice", "Carol", -79}]

    assert Day13.parse_input(input) == output
  end

  test "part1" do
    input = File.read!("test/y2015/input/day13.txt")
    output = {[{"Alice", 52}, {"Bob", 76}, {"Carol", 115}, {"David", 87}], 330}

    assert Day13.part1(input) == output
  end
end

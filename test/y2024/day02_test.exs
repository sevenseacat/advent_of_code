defmodule Y2024.Day02Test do
  use ExUnit.Case, async: true
  alias Y2024.Day02
  doctest Day02

  @input """
  7 6 4 2 1
  1 2 7 8 9
  9 7 6 2 1
  1 3 2 4 5
  8 6 4 4 1
  1 3 6 7 9
  """

  test "safe?" do
    assert Day02.safe?([7, 6, 4, 2, 1])
    refute Day02.safe?([1, 2, 7, 8, 9])
    refute Day02.safe?([9, 7, 6, 2, 1])
    refute Day02.safe?([1, 3, 2, 4, 5])
    refute Day02.safe?([8, 6, 4, 4, 1])
    assert Day02.safe?([1, 3, 6, 7, 9])
  end

  test "safe_with_problem_dampener?" do
    assert Day02.safe_with_problem_dampener?([7, 6, 4, 2, 1])
    refute Day02.safe_with_problem_dampener?([1, 2, 7, 8, 9])
    refute Day02.safe_with_problem_dampener?([9, 7, 6, 2, 1])
    assert Day02.safe_with_problem_dampener?([1, 3, 2, 4, 5])
    assert Day02.safe_with_problem_dampener?([8, 6, 4, 4, 1])
    assert Day02.safe_with_problem_dampener?([1, 3, 6, 7, 9])
  end

  test "part 1" do
    assert Day02.parse_input(@input) |> Day02.part1() == 2
  end

  test "part 2" do
    assert Day02.parse_input(@input) |> Day02.part2() == 4
  end

  test "verification, part 1", do: assert(Day02.part1_verify() == 526)
  test "verification, part 2", do: assert(Day02.part2_verify() == 566)
end

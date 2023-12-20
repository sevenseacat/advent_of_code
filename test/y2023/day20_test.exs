defmodule Y2023.Day20Test do
  use ExUnit.Case, async: true
  alias Y2023.Day20
  doctest Day20

  test "verification, part 1", do: assert(Day20.part1_verify() == 949_764_474)
  # test "verification, part 2", do: assert(Day20.part2_verify() == "update or delete me")

  @sample_1_input """
  broadcaster -> a, b, c
  %a -> b
  %b -> c
  %c -> inv
  &inv -> a
  """

  @sample_2_input """
  broadcaster -> a
  %a -> inv, con
  &inv -> b
  %b -> con
  &con -> output
  """

  describe "parse input" do
    test "sample 1" do
      actual = Day20.parse_input(@sample_1_input)

      expected = %{
        "broadcaster" => %{type: :forward, outputs: ["a", "b", "c"]},
        "a" => %{type: :flipflop, outputs: ["b"], status: :off},
        "b" => %{type: :flipflop, outputs: ["c"], status: :off},
        "c" => %{type: :flipflop, outputs: ["inv"], status: :off},
        "inv" => %{type: :conjunction, outputs: ["a"], received: %{"c" => :low}}
      }

      assert actual == expected
    end

    test "sample 2" do
      actual = Day20.parse_input(@sample_2_input)

      expected = %{
        "broadcaster" => %{type: :forward, outputs: ["a"]},
        "a" => %{type: :flipflop, outputs: ["inv", "con"], status: :off},
        "inv" => %{type: :conjunction, outputs: ["b"], received: %{"a" => :low}},
        "b" => %{type: :flipflop, outputs: ["con"], status: :off},
        "con" => %{type: :conjunction, outputs: ["output"], received: %{"a" => :low, "b" => :low}}
      }

      assert actual == expected
    end
  end

  describe "part 1" do
    test "sample 1" do
      assert Day20.parse_input(@sample_1_input) |> Day20.part1() == %{low: 8000, high: 4000}
    end

    test "sample 2" do
      input = Day20.parse_input(@sample_2_input)

      assert Day20.part1(input, 1) == %{low: 4, high: 4}
      assert Day20.part1(input, 2) == %{low: 8, high: 6}
      assert Day20.part1(input, 3) == %{low: 13, high: 9}
      assert Day20.part1(input, 4) == %{low: 17, high: 11}
      assert Day20.part1(input) == %{low: 4250, high: 2750}
    end
  end
end

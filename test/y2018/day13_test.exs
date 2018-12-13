defmodule Y2018.Day13Test do
  use ExUnit.Case, async: true
  alias Y2018.Day13
  doctest Day13

  test "verification, part 1", do: assert(Day13.part1_verify() == {129, 50})
  test "verification, part 2", do: assert(Day13.part2_verify() == {69, 73})

  describe "parse_input/1" do
    test "it parses simple loops" do
      input = test_data("simple_loop")

      expected_output = %{
        {0, 0} => {"/", nil},
        {1, 0} => {"-", nil},
        {2, 0} => {"-", nil},
        {3, 0} => {"-", nil},
        {4, 0} => {"\\", nil},
        {0, 1} => {"|", nil},
        {4, 1} => {"|", nil},
        {0, 2} => {"\\", nil},
        {1, 2} => {"-", nil},
        {2, 2} => {"-", nil},
        {3, 2} => {"-", nil},
        {4, 2} => {"/", nil}
      }

      assert Day13.parse_input(input) == expected_output
    end

    test "it can parse intersections and carts" do
      input = test_data("intersecting_carts")

      expected_output = %{
        {0, 0} => {"/", nil},
        {1, 0} => {"-", nil},
        {2, 0} => {"-", nil},
        {3, 0} => {"-", {:right, :left}},
        {4, 0} => {"-", nil},
        {5, 0} => {"-", nil},
        {6, 0} => {"\\", nil},
        {0, 1} => {"|", nil},
        {6, 1} => {"|", nil},
        {0, 2} => {"|", nil},
        {3, 2} => {"/", nil},
        {4, 2} => {"-", nil},
        {5, 2} => {"-", nil},
        {6, 2} => {"+", nil},
        {7, 2} => {"-", nil},
        {8, 2} => {"-", nil},
        {9, 2} => {"\\", nil},
        {0, 3} => {"|", nil},
        {3, 3} => {"|", {:up, :left}},
        {6, 3} => {"|", nil},
        {9, 3} => {"|", nil},
        {0, 4} => {"\\", nil},
        {1, 4} => {"-", nil},
        {2, 4} => {"-", nil},
        {3, 4} => {"+", nil},
        {4, 4} => {"-", nil},
        {5, 4} => {"-", nil},
        {6, 4} => {"/", nil},
        {9, 4} => {"|", nil},
        {3, 5} => {"|", nil},
        {9, 5} => {"|", nil},
        {3, 6} => {"\\", nil},
        {4, 6} => {"-", nil},
        {5, 6} => {"-", nil},
        {6, 6} => {"-", nil},
        {7, 6} => {"-", nil},
        {8, 6} => {"-", nil},
        {9, 6} => {"/", nil}
      }

      assert Day13.parse_input(input) == expected_output
    end
  end

  describe "tick" do
    test "can moves carts once" do
      input = test_data("crash") |> Day13.parse_input()
      output = Day13.tick(input)

      # Cart 1 has moved right
      assert Map.get(output, {2, 0}) == {"-", nil}
      assert Map.get(output, {3, 0}) == {"-", {:right, :left}}

      # Cart 2 has moved down, turned left, and faces right (next turn straight)
      assert Map.get(output, {9, 3}) == {"|", nil}
      assert Map.get(output, {9, 4}) == {"+", {:right, :straight}}
    end

    test "can moves carts twice" do
      input = test_data("crash") |> Day13.parse_input()
      output = input |> Day13.tick() |> Day13.tick()

      # Cart 1 has moved right, followed the corner, faces down
      assert Map.get(output, {2, 0}) == {"-", nil}
      assert Map.get(output, {3, 0}) == {"-", nil}
      assert Map.get(output, {4, 0}) == {"\\", {:down, :left}}

      # Cart 2 has moved right
      assert Map.get(output, {9, 3}) == {"|", nil}
      assert Map.get(output, {9, 4}) == {"+", nil}
      assert Map.get(output, {10, 4}) == {"-", {:right, :straight}}
    end

    test "goes all the way to a crash" do
      input = test_data("crash") |> Day13.parse_input()

      # The sample input crashes after 14 ticks.
      output = Enum.reduce(1..14, input, fn _, input -> Day13.tick(input) end)

      # One spot has two carts - the crash site.
      occupied = Enum.filter(output, fn {_coord, {_track, carts}} -> carts != nil end)
      assert occupied == [{{7, 3}, {"|", [{:up, :left}, {:down, :right}]}}]
    end
  end

  describe "run_until_crash" do
    test "works with the test input" do
      input = test_data("crash") |> Day13.parse_input()
      {coord, {_track, carts}} = Day13.run_until_crash(input, 0)

      assert coord == {7, 3}
      assert carts == [{:up, :left}, {:down, :right}]
    end
  end

  describe "run_removing_crashes" do
    test "works with sample data" do
      input = test_data("removing_crashes") |> Day13.parse_input()
      {coord, {_track, carts}} = Day13.run_removing_crashes(input, 0)

      assert coord == {6, 4}
      assert carts == {:up, :left}
    end

    test "works when carts cross during a tick but do not end up on the same point" do
      input = test_data("removing_crashes_overlapping") |> Day13.parse_input()
      {coord, {_track, carts}} = Day13.run_removing_crashes(input, 0)

      assert coord == {2, 4}
      assert carts == {:left, :straight}
    end
  end

  def test_data(name), do: File.read!("test/y2018/input/day13/#{name}.txt")
end

defmodule Y2018.Day13Test do
  use ExUnit.Case, async: true
  alias Y2018.{Day13, Day13.Cart}
  doctest Day13

  test "verification, part 1", do: assert(Day13.part1_verify() == {129, 50})
  test "verification, part 2", do: assert(Day13.part2_verify() == {69, 73})

  describe "parse_input/1" do
    test "it parses simple loops" do
      input = test_data("simple_loop")

      expected_output =
        {[],
         %{
           {0, 0} => "/",
           {1, 0} => "-",
           {2, 0} => "-",
           {3, 0} => "-",
           {4, 0} => "\\",
           {0, 1} => "|",
           {4, 1} => "|",
           {0, 2} => "\\",
           {1, 2} => "-",
           {2, 2} => "-",
           {3, 2} => "-",
           {4, 2} => "/"
         }}

      assert Day13.parse_input(input) == expected_output
    end

    test "it can parse intersections and carts" do
      input = test_data("intersecting_carts")

      expected_output =
        {[
           %Cart{id: 2, direction: :up, next_turn: :left, coordinates: {3, 3}, crashed: false},
           %Cart{id: 1, direction: :right, next_turn: :left, coordinates: {3, 0}, crashed: false}
         ],
         %{
           {0, 0} => "/",
           {1, 0} => "-",
           {2, 0} => "-",
           {3, 0} => "-",
           {4, 0} => "-",
           {5, 0} => "-",
           {6, 0} => "\\",
           {0, 1} => "|",
           {6, 1} => "|",
           {0, 2} => "|",
           {3, 2} => "/",
           {4, 2} => "-",
           {5, 2} => "-",
           {6, 2} => "+",
           {7, 2} => "-",
           {8, 2} => "-",
           {9, 2} => "\\",
           {0, 3} => "|",
           {3, 3} => "|",
           {6, 3} => "|",
           {9, 3} => "|",
           {0, 4} => "\\",
           {1, 4} => "-",
           {2, 4} => "-",
           {3, 4} => "+",
           {4, 4} => "-",
           {5, 4} => "-",
           {6, 4} => "/",
           {9, 4} => "|",
           {3, 5} => "|",
           {9, 5} => "|",
           {3, 6} => "\\",
           {4, 6} => "-",
           {5, 6} => "-",
           {6, 6} => "-",
           {7, 6} => "-",
           {8, 6} => "-",
           {9, 6} => "/"
         }}

      assert Day13.parse_input(input) == expected_output
    end
  end

  describe "tick" do
    test "can moves carts once" do
      input = test_data("crash") |> Day13.parse_input()
      {[cart2, cart1 | []], _grid} = Day13.tick(input)

      # Cart 1 has moved right
      assert cart1.coordinates == {3, 0}
      assert cart1.direction == :right
      assert cart1.next_turn == :left

      # Cart 2 has moved down, turned left, and faces right (next turn straight)
      assert cart2.coordinates == {9, 4}
      assert cart2.direction == :right
      assert cart2.next_turn == :straight
    end

    test "can moves carts twice" do
      input = test_data("crash") |> Day13.parse_input()
      {[cart2, cart1 | []], _grid} = Day13.tick(input) |> Day13.tick()

      # Cart 1 has moved right, followed the corner, faces down
      assert cart1.coordinates == {4, 0}
      assert cart1.direction == :down
      assert cart1.next_turn == :left

      # Cart 2 has moved right
      assert cart2.coordinates == {10, 4}
      assert cart2.direction == :right
      assert cart2.next_turn == :straight
    end

    test "goes all the way to a crash" do
      input = test_data("crash") |> Day13.parse_input()

      # The sample input crashes after 14 ticks.
      {carts, _grid} = Enum.reduce(1..14, input, fn _, input -> Day13.tick(input) end)

      # Both carts are in the same spot, and crashed
      assert Enum.all?(carts, fn cart -> cart.crashed end)
      assert Enum.all?(carts, fn cart -> cart.coordinates == {7, 3} end)
    end
  end

  describe "run_until_crash" do
    test "works with the test input" do
      input = test_data("crash") |> Day13.parse_input()
      {coord, _carts} = Day13.run_until_crash(input, 0)

      assert coord == {7, 3}
    end
  end

  describe "run_removing_crashes" do
    test "works with sample data" do
      input = test_data("removing_crashes") |> Day13.parse_input()
      last_cart = Day13.run_removing_crashes(input, 0)

      assert last_cart.coordinates == {6, 4}
      assert last_cart.direction == :up
    end

    test "works when carts cross during a tick but do not end up on the same point" do
      input = test_data("removing_crashes_overlapping") |> Day13.parse_input()
      last_cart = Day13.run_removing_crashes(input, 0)

      assert last_cart.coordinates == {2, 4}
    end
  end

  def test_data(name), do: File.read!("test/y2018/input/day13/#{name}.txt")
end

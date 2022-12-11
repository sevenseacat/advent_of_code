defmodule Y2022.Day11Test do
  use ExUnit.Case, async: true
  alias Y2022.Day11
  doctest Day11

  test "verification, part 1", do: assert(Day11.part1_verify() == 76728)
  test "verification, part 2", do: assert(Day11.part2_verify() == 21_553_910_156)

  describe "part1/1" do
    test "one round, items held" do
      {%{
         0 => %{items: items0},
         1 => %{items: items1},
         2 => %{items: items2},
         3 => %{items: items3}
       }, _answer} = Day11.part1(sample_input(), 1)

      assert items0 == [20, 23, 27, 26]
      assert items1 == [2080, 25, 167, 207, 401, 1046]
      assert items2 == []
      assert items3 == []
    end

    test "full game" do
      output =
        {%{
           0 => %{items: [10, 12, 14, 26, 34], inspections: 101},
           1 => %{items: [245, 93, 53, 199, 115], inspections: 95},
           2 => %{items: [], inspections: 7},
           3 => %{items: [], inspections: 105}
         }, 10605}

      assert output == Day11.part1(sample_input())
    end
  end

  describe "part2/1" do
    test "full game" do
      assert 2_713_310_158 == Day11.part2(sample_input()) |> elem(1)
    end
  end

  def sample_input do
    %{
      # Monkey 0:
      #   Starting items: 79, 98
      #   Operation: new = old * 19
      #   Test: divisible by 23
      #     If true: throw to monkey 2
      #     If false: throw to monkey 3
      0 => %{
        items: [79, 98],
        operation: fn val -> val * 19 end,
        divisor: 23,
        if_true: 2,
        if_false: 3,
        inspections: 0
      },

      # Monkey 1:
      #   Starting items: 54, 65, 75, 74
      #   Operation: new = old + 6
      #   Test: divisible by 19
      #     If true: throw to monkey 2
      #     If false: throw to monkey 0
      1 => %{
        items: [54, 65, 75, 74],
        operation: fn val -> val + 6 end,
        divisor: 19,
        if_true: 2,
        if_false: 0,
        inspections: 0
      },

      # Monkey 2:
      #   Starting items: 79, 60, 97
      #   Operation: new = old * old
      #   Test: divisible by 13
      #     If true: throw to monkey 1
      #     If false: throw to monkey 3
      2 => %{
        items: [79, 60, 97],
        operation: fn val -> val * val end,
        divisor: 13,
        if_true: 1,
        if_false: 3,
        inspections: 0
      },

      # Monkey 3:
      #   Starting items: 74
      #   Operation: new = old + 3
      #   Test: divisible by 17
      #     If true: throw to monkey 0
      #     If false: throw to monkey 1
      3 => %{
        items: [74],
        operation: fn val -> val + 3 end,
        divisor: 17,
        if_true: 0,
        if_false: 1,
        inspections: 0
      }
    }
  end
end

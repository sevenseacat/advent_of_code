defmodule Y2022.Day11 do
  use Advent.Day, no: 11

  def part1(input, rounds \\ 20) do
    input
    |> rounds(Map.keys(input), rounds)
    |> to_result()
  end

  defp rounds(input, _monkeys, 0), do: input

  defp rounds(input, monkeys, rounds) do
    Enum.reduce(monkeys, input, fn monkey, acc ->
      monkey_turn(monkey, acc)
    end)
    |> rounds(monkeys, rounds - 1)
  end

  defp monkey_turn(monkey_id, input) do
    monkey = Map.fetch!(input, monkey_id)

    Enum.reduce(monkey.items, input, fn item, acc ->
      worry_level = div(monkey.operation.(item), 3)
      target_monkey = target_monkey(monkey, worry_level)
      update_in(acc, [target_monkey, :items], fn items -> items ++ [worry_level] end)
    end)
    |> Map.update!(monkey_id, fn monkey ->
      %{monkey | inspections: monkey.inspections + length(monkey.items), items: []}
    end)
  end

  defp target_monkey(%{test: test, if_true: if_true, if_false: if_false}, worry_level) do
    if test.(worry_level), do: if_true, else: if_false
  end

  defp to_result(monkeys) do
    data =
      monkeys
      |> Enum.map(fn {id, data} ->
        {id, %{items: data.items, inspections: data.inspections}}
      end)
      |> Map.new()

    first_two =
      data
      |> Enum.map(fn {_id, data} -> data.inspections end)
      |> Enum.sort()
      |> Enum.reverse()
      |> Enum.take(2)
      |> Enum.reduce(&Kernel.*/2)

    {data, first_two}
  end

  # @doc """
  # iex> Day11.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  def part1_verify, do: real_input() |> part1() |> elem(1)
  # def part2_verify, do: real_input() |> part2()

  def real_input() do
    %{
      0 => %{
        items: [61],
        operation: &(&1 * 11),
        test: &(rem(&1, 5) == 0),
        if_true: 7,
        if_false: 4,
        inspections: 0
      },
      1 => %{
        items: [76, 92, 53, 93, 79, 86, 81],
        operation: &(&1 + 4),
        test: &(rem(&1, 2) == 0),
        if_true: 2,
        if_false: 6,
        inspections: 0
      },
      2 => %{
        items: [91, 99],
        operation: &(&1 * 19),
        test: &(rem(&1, 13) == 0),
        if_true: 5,
        if_false: 0,
        inspections: 0
      },
      3 => %{
        items: [58, 67, 66],
        operation: &(&1 * &1),
        test: &(rem(&1, 7) == 0),
        if_true: 6,
        if_false: 1,
        inspections: 0
      },
      4 => %{
        items: [94, 54, 62, 73],
        operation: &(&1 + 1),
        test: &(rem(&1, 19) == 0),
        if_true: 3,
        if_false: 7,
        inspections: 0
      },
      5 => %{
        items: [59, 95, 51, 58, 58],
        operation: &(&1 + 3),
        test: &(rem(&1, 11) == 0),
        if_true: 0,
        if_false: 4,
        inspections: 0
      },
      6 => %{
        items: [87, 69, 92, 56, 91, 93, 88, 73],
        operation: &(&1 + 8),
        test: &(rem(&1, 3) == 0),
        if_true: 5,
        if_false: 2,
        inspections: 0
      },
      7 => %{
        items: [71, 57, 86, 67, 96, 95],
        operation: &(&1 + 7),
        test: &(rem(&1, 17) == 0),
        if_true: 3,
        if_false: 1,
        inspections: 0
      }
    }
  end
end

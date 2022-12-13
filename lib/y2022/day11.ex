defmodule Y2022.Day11 do
  use Advent.Day, no: 11

  def part1(input, rounds \\ 20) do
    input
    |> rounds(Map.keys(input), rounds, &div(&1, 3))
    |> to_result()
  end

  def part2(input, rounds \\ 10000) do
    divisor =
      input
      |> Enum.map(fn {_id, data} -> data.divisor end)
      |> Advent.lowest_common_multiple()

    input
    |> rounds(Map.keys(input), rounds, &rem(&1, divisor))
    |> to_result()
  end

  defp rounds(input, _monkeys, 0, _worry_func), do: input

  defp rounds(input, monkeys, rounds, worry_func) do
    Enum.reduce(monkeys, input, fn monkey, acc ->
      monkey_turn(monkey, acc, worry_func)
    end)
    |> rounds(monkeys, rounds - 1, worry_func)
  end

  defp monkey_turn(monkey_id, input, worry_func) do
    monkey = Map.fetch!(input, monkey_id)

    Enum.reduce(monkey.items, input, fn item, acc ->
      worry_level = worry_func.(monkey.operation.(item))
      target_monkey = target_monkey(monkey, worry_level)
      update_in(acc, [target_monkey, :items], fn items -> items ++ [worry_level] end)
    end)
    |> Map.update!(monkey_id, fn monkey ->
      %{monkey | inspections: monkey.inspections + length(monkey.items), items: []}
    end)
  end

  defp target_monkey(%{divisor: divisor, if_true: if_true, if_false: if_false}, worry_level) do
    if rem(worry_level, divisor) == 0, do: if_true, else: if_false
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
      |> Enum.product()

    {data, first_two}
  end

  def parse_input(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_monkey/1)
    |> Map.new()
  end

  defp parse_monkey(string) do
    raw =
      ~r"Monkey (?P<id>\d):
  Starting items: (?P<items>.*)
  Operation: new = old (?<operator>\*|\+) (?P<operand>\d+|old)
  Test: divisible by (?P<divisor>\d+)
    If true: throw to monkey (?<if_true>\d+)
    If false: throw to monkey (?<if_false>\d+)"
      |> Regex.named_captures(string, capture: :all_but_first)

    {String.to_integer(raw["id"]),
     %{
       items: String.split(raw["items"], ", ") |> Enum.map(&String.to_integer/1),
       operation: build_operation(raw["operator"], raw["operand"]),
       divisor: String.to_integer(raw["divisor"]),
       if_true: String.to_integer(raw["if_true"]),
       if_false: String.to_integer(raw["if_false"]),
       inspections: 0
     }}
  end

  defp build_operation("*", "old"), do: &(&1 * &1)
  defp build_operation("*", num), do: &(&1 * String.to_integer(num))
  defp build_operation("+", num), do: &(&1 + String.to_integer(num))

  def part1_verify, do: input() |> parse_input() |> part1() |> elem(1)
  def part2_verify, do: input() |> parse_input() |> part2() |> elem(1)
end

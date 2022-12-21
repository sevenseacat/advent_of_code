defmodule Y2022.Day21 do
  use Advent.Day, no: 21

  def part1(input) do
    value_for_monkey("root", input, &do_operation/1)
  end

  # 7010269744524 - too high
  def part2(input) do
    input =
      input
      |> Map.put("humn", "???")

    [left, right] = value_for_monkey("root", input, & &1) |> tl()

    if can_evaluate?(left) do
      {do_operation(left), right}
    else
      {do_operation(right), left}
    end
    |> run_inversion()
  end

  defp can_evaluate?(list) when is_list(list), do: !Enum.member?(List.flatten(list), "???")
  defp can_evaluate?(val), do: val != "???"

  defp run_inversion({num, "???"}), do: num

  defp run_inversion({val, ["/", left, right]}) do
    if can_evaluate?(left) do
      run_inversion({div(do_operation(left), val), right})
    else
      run_inversion({val * do_operation(right), left})
    end
  end

  defp run_inversion({val, ["+", left, right]}) do
    if can_evaluate?(left) do
      run_inversion({val - do_operation(left), right})
    else
      run_inversion({val - do_operation(right), left})
    end
  end

  defp run_inversion({val, ["-", left, right]}) do
    if can_evaluate?(left) do
      run_inversion({do_operation(left) - val, right})
    else
      run_inversion({val + do_operation(right), left})
    end
  end

  defp run_inversion({val, ["*", left, right]}) do
    if can_evaluate?(left) do
      run_inversion({div(val, do_operation(left)), right})
    else
      run_inversion({div(val, do_operation(right)), left})
    end
  end

  defp value_for_monkey(monkey, input, runner) do
    case Map.get(input, monkey) do
      [monkey1, op, monkey2] ->
        runner.([
          op,
          value_for_monkey(monkey1, input, runner),
          value_for_monkey(monkey2, input, runner)
        ])

      nil ->
        raise "Can't find value for monkey #{monkey} in #{inspect(input)}"

      num ->
        num
    end
  end

  defp do_operation(num) when is_integer(num), do: num
  defp do_operation(["+", one, two]), do: do_operation(one) + do_operation(two)
  defp do_operation(["*", one, two]), do: do_operation(one) * do_operation(two)
  defp do_operation(["-", one, two]), do: do_operation(one) - do_operation(two)
  defp do_operation(["/", one, two]), do: div(do_operation(one), do_operation(two))

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
    |> Enum.into(%{})
  end

  defp parse_row(row) do
    [name, op] = String.split(row, ": ", parts: 2)
    {name, parse_op(op)}
  end

  defp parse_op(op) do
    if String.contains?(op, " ") do
      String.split(op, " ")
    else
      String.to_integer(op)
    end
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

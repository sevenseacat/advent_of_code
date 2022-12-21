defmodule Y2022.Day21 do
  use Advent.Day, no: 21

  def part1(input) do
    monkey_value("root", input, &evaluate/1)
  end

  # 7010269744524 - too high
  def part2(input) do
    input =
      input
      |> Map.update!("root", fn [a, _op, b] -> [a, "=", b] end)
      |> Map.put("humn", "???")

    run_inversion({0, monkey_value("root", input, & &1)})
  end

  defp can_evaluate?(list) when is_list(list), do: !Enum.member?(List.flatten(list), "???")
  defp can_evaluate?(val), do: val != "???"

  defp run_inversion({num, "???"}), do: num

  defp run_inversion({current, ["=", left, right]}) do
    replace_val = fn _, val -> evaluate(val) end
    left_or_right(current, [left, right], replace_val, replace_val)
  end

  defp run_inversion({current, ["/", left, right]}) do
    left_or_right(current, [left, right], &div(evaluate(&2), &1), &(&1 * evaluate(&2)))
  end

  defp run_inversion({current, ["+", left, right]}) do
    subtract_fn = fn current, val -> current - evaluate(val) end
    left_or_right(current, [left, right], subtract_fn, subtract_fn)
  end

  defp run_inversion({current, ["-", left, right]}) do
    left_or_right(current, [left, right], &(evaluate(&2) - &1), &(&1 + evaluate(&2)))
  end

  defp run_inversion({current, ["*", left, right]}) do
    division_fn = fn current, val -> div(current, evaluate(val)) end
    left_or_right(current, [left, right], division_fn, division_fn)
  end

  defp monkey_value(monkey, input, runner) do
    case Map.get(input, monkey) do
      [monkey1, op, monkey2] ->
        runner.([op, monkey_value(monkey1, input, runner), monkey_value(monkey2, input, runner)])

      nil ->
        raise "Can't find value for monkey #{monkey} in #{inspect(input)}"

      num ->
        num
    end
  end

  defp evaluate(num) when is_integer(num), do: num
  defp evaluate(["+", one, two]), do: evaluate(one) + evaluate(two)
  defp evaluate(["*", one, two]), do: evaluate(one) * evaluate(two)
  defp evaluate(["-", one, two]), do: evaluate(one) - evaluate(two)
  defp evaluate(["/", one, two]), do: div(evaluate(one), evaluate(two))

  def left_or_right(current, [left, right], left_fn, right_fn) do
    if can_evaluate?(left) do
      {left_fn.(current, left), right}
    else
      {right_fn.(current, right), left}
    end
    |> run_inversion()
  end

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

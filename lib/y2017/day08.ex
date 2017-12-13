defmodule Y2017.Day08 do
  use Advent.Day, no: 08

  def part1(input) do
    input
    |> parse_input
    |> do_part1(%{})
    |> max_key_value
  end

  def part2(input) do
    input
    |> parse_input
    |> do_part2(%{}, {nil, nil})
  end

  defp do_part1([], data), do: data

  defp do_part1([instruction | instructions], data) do
    do_part1(instructions, apply_instruction(instruction, data))
  end

  defp do_part2([], _, max), do: max

  defp do_part2([instruction | instructions], data, {x1, y1}) do
    new_data = apply_instruction(instruction, data)
    {x2, y2} = max_key_value(new_data)

    new_max =
      case y1 == nil || y2 > y1 do
        true -> {x2, y2}
        false -> {x1, y1}
      end

    do_part2(instructions, new_data, new_max)
  end

  defp max_key_value(map), do: Enum.max_by(map, fn {_, b} -> b end)

  @doc """
  iex> Day08.parse_input("b inc 5 if a > 1")
  [%{register: "b", operation: "inc", value: 5, condition: %{register: "a", operand: ">", value: 1}}]
  """
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    data =
      Regex.named_captures(
        ~r/(?<a>\w+) (?<b>inc|dec) (?<c>-*\d+) if (?<d>\w+) (?<e>[><=!]+) (?<f>-*\d+)/,
        line
      )

    %{
      register: data["a"],
      operation: data["b"],
      value: String.to_integer(data["c"]),
      condition: %{register: data["d"], operand: data["e"], value: String.to_integer(data["f"])}
    }
  end

  defp apply_instruction(instruction, data) do
    data = Map.put_new(data, instruction.register, 0)

    case condition_applies?(instruction.condition, data) do
      true ->
        Map.update!(
          data,
          instruction.register,
          &apply_operation(&1, instruction.operation, instruction.value)
        )

      false ->
        data
    end
  end

  defp condition_applies?(%{register: register, operand: operand, value: value}, data) do
    data
    |> Map.get(register, 0)
    |> check_condition(operand, value)
  end

  defp check_condition(a, operand, b) do
    case operand do
      ">" -> a > b
      "<" -> a < b
      ">=" -> a >= b
      "<=" -> a <= b
      "!=" -> a != b
      "==" -> a == b
      _ -> raise "unknown operator"
    end
  end

  defp apply_operation(a, "inc", b), do: a + b
  defp apply_operation(a, "dec", b), do: a - b

  def part1_verify, do: input() |> part1() |> elem(1)
  def part2_verify, do: input() |> part2() |> elem(1)
end

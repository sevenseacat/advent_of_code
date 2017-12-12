defmodule Y2017.Day08 do
  use Advent.Day, no: 08

  def part1(input) do
    input
    |> parse_input
    |> do_part1(%{})
    |> Enum.max_by(fn {_, b} -> b end)
  end

  def do_part1([], data), do: data

  def do_part1([instruction | instructions], data) do
    do_part1(instructions, apply_instruction(instruction, data))
  end

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

  defp check_condition(a, ">", b), do: a > b
  defp check_condition(a, "<", b), do: a < b
  defp check_condition(a, ">=", b), do: a >= b
  defp check_condition(a, "<=", b), do: a <= b
  defp check_condition(a, "!=", b), do: a != b
  defp check_condition(a, "==", b), do: a == b

  defp apply_operation(a, "inc", b), do: a + b
  defp apply_operation(a, "dec", b), do: a - b

  def part1_verify, do: input() |> part1() |> elem(1)
end

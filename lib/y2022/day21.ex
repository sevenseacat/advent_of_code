defmodule Y2022.Day21 do
  use Advent.Day, no: 21

  def part1(input) do
    value_for_monkey("root", input)
  end

  # @doc """
  # iex> Day21.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp value_for_monkey(monkey, input) do
    case Map.get(input, monkey) do
      num when is_integer(num) ->
        num

      [monkey1, op, monkey2] ->
        do_operation(op, value_for_monkey(monkey1, input), value_for_monkey(monkey2, input))

      nil ->
        raise "Can't find value for monkey #{monkey} in #{inspect(input)}"
    end
  end

  defp do_operation("+", one, two), do: one + two
  defp do_operation("*", one, two), do: one * two
  defp do_operation("-", one, two), do: one - two
  defp do_operation("/", one, two), do: div(one, two)

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
  # def part2_verify, do: input() |> parse_input() |> part2()
end

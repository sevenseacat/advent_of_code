defmodule Y2024.Day07 do
  use Advent.Day, no: 07

  def part1(input) do
    do_parts(input, [&Kernel.+/2, &Kernel.*/2])
  end

  def part2(input) do
    do_parts(input, [&Kernel.+/2, &Kernel.*/2, &concat/2])
  end

  defp do_parts(input, operands) do
    input
    |> Task.async_stream(fn row -> {elem(row, 0), valid?(row, operands)} end)
    |> Enum.reduce(0, fn {:ok, {value, result}}, acc ->
      if result, do: acc + value, else: acc
    end)
  end

  def valid?({total, list}, operands) do
    operands
    |> Advent.permutations_with_repetitions(length(list) - 1)
    |> Enum.any?(fn op_list -> equals?(total, list, op_list) end)
  end

  defp equals?(total, [result], []), do: total == result

  defp equals?(total, [num1, num2 | rest], [op1 | op_rest]) do
    equals?(total, [op1.(num1, num2) | rest], op_rest)
  end

  defp concat(one, two), do: "#{one}#{two}" |> String.to_integer()

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(row) do
    [first, rest] = String.split(row, ": ")
    {String.to_integer(first), String.split(rest, " ") |> Enum.map(&String.to_integer/1)}
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

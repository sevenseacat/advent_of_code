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
    |> Task.async_stream(fn {total, list} -> {total, valid?({total, list}, operands)} end)
    |> Enum.reduce(0, fn {:ok, {value, result}}, acc ->
      if result, do: acc + value, else: acc
    end)
  end

  def valid?({total, list}, operands) do
    check_valid(total, [list], [], operands)
  end

  def check_valid(_total, [], [], _), do: false

  def check_valid(total, [], next, operands), do: check_valid(total, next, [], operands)

  def check_valid(total, [[num] | next], [], operands) do
    num == total || check_valid(total, next, [], operands)
  end

  def check_valid(total, [[num1, num2 | rest] | next], next_level, operands) do
    if num1 > total || num2 > total do
      check_valid(total, next, next_level, operands)
    else
      next_states = Enum.map(operands, fn op -> [op.(num1, num2) | rest] end)
      check_valid(total, next, next_states ++ next_level, operands)
    end
  end

  def concat(one, two), do: "#{one}#{two}" |> String.to_integer()

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

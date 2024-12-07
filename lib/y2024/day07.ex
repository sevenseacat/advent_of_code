defmodule Y2024.Day07 do
  use Advent.Day, no: 07

  def part1(input) do
    do_parts(input, [&Kernel.+/2, &Kernel.*/2])
  end

  def part2(input) do
    do_parts(input, [&Kernel.+/2, &Kernel.*/2, &concat/2])
  end

  defp do_parts(input, operators) do
    input
    |> Task.async_stream(fn {total, list} -> {total, valid?({total, list}, operators)} end)
    |> Enum.reduce(0, fn {:ok, {value, result}}, acc ->
      if result, do: acc + value, else: acc
    end)
  end

  def valid?({total, [num]}, _), do: total == num

  def valid?({total, [num1, num2 | list]}, operators) do
    Enum.any?(operators, fn op -> valid?({total, [op.(num1, num2) | list]}, operators) end)
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

defmodule Y2024.Day05 do
  use Advent.Day, no: 05

  def part1({deps, manuals}) do
    manuals
    |> Enum.filter(&in_order?(&1, deps))
    |> Enum.map(fn manual ->
      Enum.at(manual, floor(length(manual) / 2))
    end)
    |> Enum.sum()
  end

  def part2({deps, manuals}) do
    manuals
    |> Enum.reject(&in_order?(&1, deps))
    |> Task.async_stream(fn manual ->
      manual
      |> fix_order(deps)
      |> Enum.at(floor(length(manual) / 2))
    end)
    |> Enum.reduce(0, fn {:ok, val}, acc -> acc + val end)
  end

  def in_order?([], _), do: true

  def in_order?([num1 | rest], deps) do
    !Enum.any?(rest, fn num2 -> MapSet.member?(deps, {num2, num1}) end) && in_order?(rest, deps)
  end

  defp find_invalid([num1 | rest], deps) do
    if result = Enum.find(rest, fn num2 -> MapSet.member?(deps, {num2, num1}) end) do
      {result, num1}
    else
      find_invalid(rest, deps)
    end
  end

  def fix_order(manual, deps) do
    {num2, num1} = find_invalid(manual, deps)
    manual = List.delete(manual, num2)
    pos1 = Enum.find_index(manual, &(&1 == num1))
    manual = List.insert_at(manual, pos1, num2)

    if in_order?(manual, deps) do
      manual
    else
      fix_order(manual, deps)
    end
  end

  def parse_input(input) do
    [deps, manuals] =
      input
      |> String.split("\n\n", trim: true, parts: 2)
      |> Enum.map(&String.split(&1, "\n", trim: true))

    {Enum.map(deps, &parse_dep/1) |> MapSet.new(), Enum.map(manuals, &parse_manual/1)}
  end

  defp parse_dep(string) do
    string
    |> String.split("|", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  defp parse_manual(string) do
    string
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

defmodule Y2019.Day04 do
  use Advent.Day, no: 4

  @input 197_487..673_251

  def part1(range \\ @input) do
    Enum.count(range, &meets_part1_criteria?/1)
  end

  def part2(range \\ @input) do
    Enum.count(range, &meets_part2_criteria?/1)
  end

  @doc """
  iex> Day04.meets_part1_criteria?(111111)
  true

  iex> Day04.meets_part1_criteria?(223450)
  false

  iex> Day04.meets_part1_criteria?(123789)
  false
  """
  def meets_part1_criteria?(num) do
    str = Integer.to_string(num) |> String.codepoints()
    has_double?(str) && no_decreases?(str)
  end

  @doc """
  iex> Day04.meets_part2_criteria?(112233)
  true

  iex> Day04.meets_part2_criteria?(123444)
  false

  iex> Day04.meets_part2_criteria?(111122)
  true
  """
  def meets_part2_criteria?(num) do
    str = Integer.to_string(num) |> String.codepoints()
    no_decreases?(str) && has_part2_double?(str)
  end

  # https://www.rosettacode.org/wiki/Letter_frequency#Elixir
  def frequencies(str) do
    Enum.reduce(str, Map.new(), fn c, acc -> Map.update(acc, c, 1, &(&1 + 1)) end)
  end

  defp has_double?(str) do
    Enum.any?(frequencies(str), fn {_, v} -> v >= 2 end)
  end

  defp has_part2_double?(str) do
    Enum.any?(frequencies(str), fn {_, v} -> v == 2 end)
  end

  defp no_decreases?([_]), do: true
  defp no_decreases?([a, b | rest]) when a <= b, do: no_decreases?([b | rest])
  defp no_decreases?(_), do: false

  def part1_verify, do: part1()
  def part2_verify, do: part2()
end

defmodule Y2019.Day04 do
  use Advent.Day, no: 4

  @input 197_487..673_251

  def part1(range \\ @input) do
    Enum.count(range, &meets_criteria?/1)
  end

  def part2() do
  end

  @doc """
  iex> Day04.meets_criteria?(111111)
  true

  iex> Day04.meets_criteria?(223450)
  false

  iex> Day04.meets_criteria?(123789)
  false
  """
  def meets_criteria?(num) do
    str = Integer.to_string(num) |> String.codepoints()
    has_double?(str) && no_decreases?(str)
  end

  def has_double?([a, a | _]), do: true
  def has_double?([_, b | rest]), do: has_double?([b | rest])
  def has_double?([_ | _]), do: false

  def no_decreases?([_]), do: true
  def no_decreases?([a, b | rest]) when a <= b, do: no_decreases?([b | rest])
  def no_decreases?(_), do: false

  def part1_verify, do: part1()
end

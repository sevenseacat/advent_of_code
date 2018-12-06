defmodule Y2019.Day16 do
  use Advent.Day, no: 16

  alias Y2019.Day16.PatternKeeper

  @doc """
  iex> Day16.part1("12345678", 1)
  "48226158"

  iex> Day16.part1("12345678", 2)
  "34040438"

  iex> Day16.part1("12345678", 3)
  "03415518"

  iex> Day16.part1("12345678", 4)
  "01029498"

  iex> Day16.part1("80871224585914546619083218645595", 100)
  "24176176"

  iex> Day16.part1("19617804207202209144916044189917", 100)
  "73745418"

  iex> Day16.part1("69317163492948606335995924319873", 100)
  "52432133"
  """
  def part1(input, phase) do
    PatternKeeper.start_link()

    input
    |> parse_input
    |> do_parts(0, phase)
    |> Enum.take(8)
    |> to_output
  end

  defp do_parts(input, phase, phase), do: input

  defp do_parts(input, phase, target_phase) do
    1..length(input)
    |> Advent.pmap(fn i -> calculate_digit(input, i - 1) end)
    |> do_parts(phase + 1, target_phase)
  end

  defp calculate_digit(input, digit) do
    pattern = PatternKeeper.get_pattern_for_digit(digit)

    input
    |> Enum.zip(Stream.cycle(pattern))
    |> Enum.reduce(0, fn {a, b}, acc -> acc + a * b end)
    |> rem(10)
    |> abs
  end

  defp parse_input(input) do
    input
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  defp to_output(list) do
    list
    |> Enum.map(&Integer.to_string/1)
    |> List.to_string()
  end

  def part1_verify, do: input() |> part1(100)
end
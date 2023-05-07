defmodule Y2019.Day16 do
  use Advent.Day, no: 16

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
    input
    |> parse_input
    |> do_parts(0, phase)
    |> Enum.take(8)
    |> to_output
  end

  defp do_parts(input, phase, phase), do: input

  defp do_parts(input, phase, target_phase) do
    # Add a zero to simulate dropping the first value of the pattern
    input = [0 | input]

    1..length(input)
    |> Enum.map(fn i -> calculate_digit(input, i - 1) end)
    |> do_parts(phase + 1, target_phase)
  end

  defp calculate_digit(input, digit) do
    input
    |> Stream.chunk_every(digit + 1)
    |> Stream.drop(1)
    |> Stream.take_every(2)
    |> Enum.reduce({0, true}, fn list, {acc, add?} ->
      list_sum = Enum.sum(list)
      if add?, do: {acc + list_sum, false}, else: {acc - list_sum, true}
    end)
    |> elem(0)
    |> rem(10)
    |> abs()
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

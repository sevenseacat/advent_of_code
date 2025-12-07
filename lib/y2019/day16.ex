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
    |> do_part1(0, phase)
    |> Enum.take(8)
    |> to_output
  end

  @doc """
  iex> Day16.part2("03036732577212944063491565474664", 100)
  "84462026"

  iex> Day16.part2("02935109699940807407585447034323", 100)
  "78725270"

  iex> Day16.part2("03081770884921959731165446850517", 100)
  "53553731"
  """
  def part2(input, phase) do
    offset = String.slice(input, 0, 7) |> String.to_integer()

    input
    |> parse_input
    |> Nx.tensor()
    |> Nx.tile([10000])
    |> Nx.split(offset)
    |> elem(1)
    |> do_part2(0, phase)
    |> Nx.slice([0], [8])
    |> Nx.to_flat_list()
    |> to_output()
  end

  defp do_part1(input, phase, phase), do: input

  defp do_part1(input, phase, target_phase) do
    # Add a zero to simulate dropping the first value of the pattern
    input = [0 | input]

    1..length(input)
    |> Enum.map(fn i -> calculate_digit(input, i - 1) end)
    |> do_part1(phase + 1, target_phase)
  end

  defp do_part2(input, phase, phase), do: input

  defp do_part2(input, phase, target_phase) do
    # This puzzle is evil genius. Because we don't care about the start of the
    # string, only a small section right near the end of the string, all of the
    # digits in that section will fall at the change between the 0 and 1 parts
    # of the repeating pattern.
    #
    # eg. 0 0 0 0 1 1 1 1 1 1 1 1 1 ... # pattern
    #     8 9 9 2 3 9 8 4 3 2 3 4 5 ... # digits
    #             ^ for this digit
    #
    # So the value for each digit is.... the sum of the rest of the list from
    # that point on.
    #
    # And it can be calculated in one hit for the whole list, with a _reverse
    # cumulative sum_ (summing from an index to the end of the list).
    #
    # So a "phase" is one reverse cumulative sum of the last part of the list,
    # plus the rem/abs steps.
    #
    # And Nx makes this really easy.
    #
    # The FFT from the problem description is a massive red herring - it *is*
    # doable with a fast Fourier transform, and that's probably the "correct"
    # way to do it, but.... that's some hardcore maths. I did try, with a lot
    # more Nx tinkering, but didn't figure out the relationship between the
    # generated FFT and the repeating pattern.
    Nx.cumulative_sum(input, reverse: true)
    |> Nx.remainder(10)
    |> Nx.abs()
    |> do_part2(phase + 1, target_phase)
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
  def part2_verify, do: input() |> part2(100)
end

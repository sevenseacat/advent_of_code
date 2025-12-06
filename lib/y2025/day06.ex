defmodule Y2025.Day06 do
  use Advent.Day, no: 06

  def parts(input) do
    Enum.sum_by(input, &evaluate/1)
  end

  defp evaluate({[num | nums], op}) do
    Enum.reduce(nums, num, fn num, acc ->
      apply(Kernel, op, [num, acc])
    end)
  end

  # This is an awful function but it works?
  def parse_input(input, opt \\ nil) do
    rows = String.split(input, "\n", trim: true)
    cols = Enum.max(Enum.map(rows, &String.length/1))

    {last, spaces} =
      Enum.filter(0..cols, fn col ->
        Enum.all?(rows, &(String.at(&1, col) == " "))
      end)
      |> Enum.reduce({0, []}, fn num, {prev, acc} ->
        {num, [num - prev | acc]}
      end)

    spaces = Enum.reverse([last | spaces])

    [ops | nums] =
      rows
      |> Enum.map(fn row ->
        spaces
        |> Enum.reduce({row, []}, fn space, {row, acc} ->
          {chunk, rest} = String.split_at(row, space)
          {rest, [chunk | acc]}
        end)
        |> elem(1)
        |> Enum.reverse()
      end)
      |> Enum.reverse()

    ops =
      Enum.map(ops, fn op ->
        op
        |> String.trim()
        |> String.to_atom()
      end)

    nums =
      nums
      |> Enum.reverse()
      |> Advent.transpose()

    if opt == :transpose do
      nums
      |> Enum.map(fn num_row ->
        max_length = Enum.max_by(num_row, &String.length/1) |> String.length()

        num_row
        |> Enum.map(&String.pad_trailing(&1, max_length))
        |> Enum.map(&String.graphemes/1)
        |> Advent.transpose()
        |> Enum.map(&Enum.join/1)
        |> Enum.map(&String.trim/1)
        |> Enum.reject(&(&1 == ""))
        |> Enum.reverse()
      end)
    else
      nums
    end
    |> Enum.map(fn num_row ->
      Enum.map(num_row, fn num ->
        num
        |> String.trim()
        |> String.to_integer()
      end)
    end)
    |> Enum.zip(ops)
  end

  def part1_verify, do: input() |> parse_input() |> parts()
  def part2_verify, do: input() |> parse_input(:transpose) |> parts()
end

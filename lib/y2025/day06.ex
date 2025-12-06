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
    rows = Enum.map(rows, &String.pad_trailing(&1, cols))

    spaces = find_space_columns(rows)

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
        num_row
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
    |> convert_strings_to_nums()
    |> Enum.zip(ops)
  end

  defp find_space_columns(rows) do
    rows
    |> Enum.map(&String.codepoints(&1))
    |> iterate_over_rows(0)
  end

  defp iterate_over_rows(rows, index) do
    if Enum.any?(rows, &Enum.empty?(&1)) do
      [index]
    else
      tls = Enum.map(rows, &tl(&1))

      if Enum.all?(rows, &(hd(&1) == " ")) do
        [index | iterate_over_rows(tls, 1)]
      else
        iterate_over_rows(tls, index + 1)
      end
    end
  end

  defp convert_strings_to_nums(rows) do
    Enum.map(rows, fn num_row ->
      Enum.map(num_row, fn num ->
        num
        |> String.trim()
        |> String.to_integer()
      end)
    end)
  end

  def part1_verify, do: input() |> parse_input() |> parts()
  def part2_verify, do: input() |> parse_input(:transpose) |> parts()
end

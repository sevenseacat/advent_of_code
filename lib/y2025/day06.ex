defmodule Y2025.Day06 do
  use Advent.Day, no: 06

  def part1(input) do
    Enum.sum_by(input, &evaluate/1)
  end

  # @doc """
  # iex> Day06.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp evaluate(row) do
    [op | nums] = Enum.reverse(row)

    Enum.reduce(tl(nums), hd(nums), fn num, acc ->
      apply(Kernel, op, [num, acc])
    end)
  end

  # This is an awful function but it works?
  def parse_input(input) do
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
      Enum.map(nums, fn num_row ->
        Enum.map(num_row, fn num ->
          num
          |> String.trim()
          |> String.to_integer()
        end)
      end)

    [ops | nums]
    |> Enum.reverse()
    |> Advent.transpose()
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end

defmodule Y2023.Day09 do
  use Advent.Day, no: 09

  def part1(input) do
    input
    |> Enum.map(&next_value_in_sequence/1)
    |> Enum.sum()
  end

  # @doc """
  # iex> Day09.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  @doc """
  iex> Day09.next_value_in_sequence([0, 3, 6, 9, 12, 15])
  18

  iex> Day09.next_value_in_sequence([1, 3, 6, 10, 15, 21])
  28

  iex> Day09.next_value_in_sequence([10, 13, 16, 21, 30, 45])
  68
  """
  def next_value_in_sequence(list, acc \\ 0) do
    acc = acc + List.last(list)

    if Enum.all?(list, &(&1 == 0)) do
      acc
    else
      new_list = differences_in_sequence(list)
      next_value_in_sequence(new_list, acc)
    end
  end

  defp differences_in_sequence(list, new_list \\ [])
  defp differences_in_sequence([_item], list), do: Enum.reverse(list)

  defp differences_in_sequence([a, b | rest], list) do
    differences_in_sequence([b | rest], [b - a | list])
  end

  def parse_input(input) do
    for row <- String.split(input, "\n", trim: true) do
      row
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
    end
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end

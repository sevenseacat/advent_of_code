defmodule Y2016.Day20 do
  use Advent.Day, no: 20

  @doc """
  iex> Day20.part1([{5,8}, {0,2}, {4,7}])
  3
  """
  def part1(input) do
    input
    |> Enum.sort_by(fn {low, _high} -> low end)
    |> do_part1(0)
  end

  defp do_part1(ranges, check) do
    case Enum.find(ranges, fn {low, high} -> check >= low && check <= high end) do
      nil -> check
      {_low, high} -> do_part1(ranges, high + 1)
    end
  end

  @doc """
  iex> Day20.parse_input("5-8\\n2-7\\n1-311111\\n")
  [{5,8}, {2,7}, {1,311111}]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(row) do
    row
    |> String.split("-", parts: 2)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def part1_verify, do: input() |> parse_input() |> part1()
end

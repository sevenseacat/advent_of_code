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
  iex> Day20.part2([{5,8}, {0,2}, {4,7}], 9)
  2

  iex> Day20.part2([{1,3}], 5)
  3
  """
  def part2(input, max \\ 4_294_967_295) do
    sorted =
      input
      |> Enum.sort_by(fn {low, _high} -> low end)
      |> consolidate_overlaps()

    sum_gaps(sorted, max, elem(hd(sorted), 0))
  end

  defp consolidate_overlaps([last]), do: [last]

  defp consolidate_overlaps([{one_low, one_high} = one, {two_low, two_high} = two | rest]) do
    cond do
      # one totally overlaps two
      one_low <= two_low && one_high >= two_high -> consolidate_overlaps([one | rest])
      # one partially overlaps two
      one_high >= two_low -> consolidate_overlaps([{one_low, max(one_high, two_high)} | rest])
      true -> [one | consolidate_overlaps([two | rest])]
    end
  end

  defp sum_gaps([{_one_low, one_high}, {two_low, _two_high} = two | rest], max, count) do
    sum_gaps([two | rest], max, count + (two_low - one_high - 1))
  end

  defp sum_gaps([{_one_low, one_high}], max, count) do
    count + (max - one_high)
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
  def part2_verify, do: input() |> parse_input() |> part2()
end

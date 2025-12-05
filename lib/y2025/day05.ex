defmodule Y2025.Day05 do
  use Advent.Day, no: 05

  def part1({ranges, available}) do
    available
    |> Enum.filter(&fresh?(&1, ranges))
    |> length()
  end

  def part2({ranges, _available}) do
    ranges
    |> Enum.sort()
    |> remove_contained_ranges()
    |> combine_overlapping_ranges()
    |> Enum.sum_by(fn {from, to} -> to - from + 1 end)
  end

  defp remove_contained_ranges(ranges) do
    ranges
    |> Enum.reject(fn {from_a, to_a} ->
      Enum.any?(ranges, fn {from_b, to_b} ->
        from_a != from_b && to_a != to_b && from_a >= from_b && to_a <= to_b
      end)
    end)
  end

  defp combine_overlapping_ranges([]), do: []

  defp combine_overlapping_ranges([{from_a, to_a} | rest]) do
    overlap_index =
      Enum.find_index(rest, fn {from_b, to_b} ->
        # |       |         a
        #     |        |    b
        from_b >= from_a && from_b <= to_a && to_b >= to_a
      end)

    case overlap_index do
      nil ->
        [{from_a, to_a} | combine_overlapping_ranges(rest)]

      index ->
        {{_, to_b}, rest} = List.pop_at(rest, index)
        combine_overlapping_ranges([{from_a, to_b} | rest])
    end
  end

  defp fresh?(number, ranges) do
    Enum.any?(ranges, fn {from, to} -> number >= from && number <= to end)
  end

  @doc """
  iex> Day05.parse_input("3-5\\n10-14\\n12-18\\n\\n1\\n5\\n8")
  {[{3,5}, {10,14}, {12,18}], [1,5,8]}
  """
  def parse_input(input) do
    [ranges, available] = String.split(input, "\n\n", trim: true)
    {parse_ranges(ranges), parse_available(available)}
  end

  # Very similar to day 2 input except newline-separated instead of comma-separated
  defp parse_ranges(ranges) do
    ranges
    |> String.split("\n", trim: true)
    |> Enum.map(fn range ->
      range |> String.split("-") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
    end)
  end

  defp parse_available(available) do
    available
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

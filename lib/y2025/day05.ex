defmodule Y2025.Day05 do
  use Advent.Day, no: 05

  def part1({ranges, available}) do
    available
    |> Enum.filter(&fresh?(&1, ranges))
    |> length()
  end

  # @doc """
  # iex> Day05.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

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
  # def part2_verify, do: input() |> parse_input() |> part2()
end

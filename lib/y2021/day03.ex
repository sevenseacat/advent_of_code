defmodule Y2021.Day03 do
  use Advent.Day, no: 3

  @doc """
  iex> Day03.part1(["00100", "11110", "10110", "10111", "10101", "01111", "00111", "11100", "10000",
  ...> "11001", "00010", "01010"])
  {22, 9, 198}
  """
  def part1(input) do
    gamma = gamma_rate(input)
    epsilon = epsilon_rate(input, gamma)
    {gamma, epsilon, gamma * epsilon}
  end

  @doc """
  iex> Day03.part2(["00100", "11110", "10110", "10111", "10101", "01111", "00111", "11100", "10000",
  ...> "11001", "00010", "01010"])
  {23, 10, 230}
  """
  def part2(input) do
    oxygen = rating_by_reduction(input, :high, "1")
    co2 = rating_by_reduction(input, :low, "0")
    {oxygen, co2, oxygen * co2}
  end

  defp rating_by_reduction(strings, high_or_low, tiebreaker, position \\ 0)

  defp rating_by_reduction([string], _, _, _) do
    {val, _rest} = Integer.parse(string, 2)
    val
  end

  defp rating_by_reduction(strings, high_or_low, tiebreaker, position) do
    strings
    |> filter_by_commonality(high_or_low, position, tiebreaker)
    |> rating_by_reduction(high_or_low, tiebreaker, position + 1)
  end

  @doc """
  iex> Day03.filter_by_commonality(["00100", "11110", "10110", "10111", "10101", "01111", "00111", "11100", "10000",
  ...> "11001", "00010", "01010"], :high, 0, "1")
  ["11110", "10110", "10111", "10101", "11100", "10000", "11001"]

  iex> Day03.filter_by_commonality(["11110", "10110", "10111", "10101", "11100", "10000", "11001"], :high, 1, "1")
  ["10110", "10111", "10101", "10000"]

  iex> Day03.filter_by_commonality(["10110", "10111", "10101", "10000"], :high, 2, "1")
  ["10110", "10111", "10101"]

  iex> Day03.filter_by_commonality(["10110", "10111", "10101"], :high, 3, "1")
  ["10110", "10111"]

  iex> Day03.filter_by_commonality(["10110", "10111"], :high, 4, "1")
  ["10111"]

  iex> Day03.filter_by_commonality(["00100", "11110", "10110", "10111", "10101", "01111", "00111", "11100", "10000",
  ...> "11001", "00010", "01010"], :low, 0, "0")
  ["00100", "01111", "00111", "00010", "01010"]

  iex> Day03.filter_by_commonality(["00100", "01111", "00111", "00010", "01010"], :low, 1, "0")
  ["01111", "01010"]

  iex> Day03.filter_by_commonality(["01111", "01010"], :low, 2, "0")
  ["01010"]
  """
  def filter_by_commonality(list, high_or_low, position, tiebreaker) do
    preferred_value =
      list
      |> most_common_value(position, length(list))
      |> to_preferred_value(high_or_low, tiebreaker)

    list
    |> Enum.filter(fn item -> String.at(item, position) == preferred_value end)
  end

  defp gamma_rate(input) do
    max = length(input)

    0..(String.length(hd(input)) - 1)
    |> Enum.map(fn position -> most_common_value(input, position, max) end)
    |> List.to_string()
    |> Integer.parse(2)
    |> elem(0)
  end

  defp epsilon_rate(input, gamma) do
    # The inverse binary value, eg. the maximum binary value that can be encoded minus the gamma value.
    max = :math.pow(2, String.length(hd(input))) |> round
    max - gamma - 1
  end

  defp most_common_value(strings, position, max_value) do
    count_ones(strings, position) |> to_binary_value(max_value)
  end

  defp count_ones(strings, position) do
    Enum.count(strings, fn string -> String.at(string, position) == "1" end)
  end

  defp to_binary_value(value, max) when value * 2 > max, do: "1"
  defp to_binary_value(value, max) when value * 2 < max, do: "0"
  defp to_binary_value(_, _), do: nil

  defp to_preferred_value(nil, _high_or_low, tie), do: tie
  defp to_preferred_value(val, :high, _tie), do: val
  defp to_preferred_value("0", :low, _tie), do: "1"
  defp to_preferred_value("1", :low, _tie), do: "0"

  def part1_verify, do: input() |> String.split("\n") |> part1() |> elem(2)
  def part2_verify, do: input() |> String.split("\n") |> part2() |> elem(2)
end

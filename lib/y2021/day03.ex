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
    oxygen = rating_by_reduction(input, &most_common/2)
    co2 = rating_by_reduction(input, &least_common/2)

    {oxygen, co2, oxygen * co2}
  end

  def most_common(zeros, ones), do: if(ones >= zeros, do: "1", else: "0")
  def least_common(zeros, ones), do: if(ones < zeros, do: "1", else: "0")

  defp rating_by_reduction(strings, comp_func, position \\ 0)

  defp rating_by_reduction([string], _, _) do
    String.to_integer(string, 2)
  end

  defp rating_by_reduction(strings, comp_func, position) do
    strings
    |> filter_by_commonality(comp_func, position)
    |> rating_by_reduction(comp_func, position + 1)
  end

  @doc """
  iex> Day03.filter_by_commonality(["00100", "11110", "10110", "10111", "10101", "01111", "00111", "11100", "10000",
  ...> "11001", "00010", "01010"], &Day03.most_common/2, 0)
  ["11110", "10110", "10111", "10101", "11100", "10000", "11001"]

  iex> Day03.filter_by_commonality(["11110", "10110", "10111", "10101", "11100", "10000", "11001"], &Day03.most_common/2, 1)
  ["10110", "10111", "10101", "10000"]

  iex> Day03.filter_by_commonality(["10110", "10111", "10101", "10000"], &Day03.most_common/2, 2)
  ["10110", "10111", "10101"]

  iex> Day03.filter_by_commonality(["10110", "10111", "10101"], &Day03.most_common/2, 3)
  ["10110", "10111"]

  iex> Day03.filter_by_commonality(["10110", "10111"], &Day03.most_common/2, 4)
  ["10111"]

  iex> Day03.filter_by_commonality(["00100", "11110", "10110", "10111", "10101", "01111", "00111", "11100", "10000",
  ...> "11001", "00010", "01010"], &Day03.least_common/2, 0)
  ["00100", "01111", "00111", "00010", "01010"]

  iex> Day03.filter_by_commonality(["00100", "01111", "00111", "00010", "01010"], &Day03.least_common/2, 1)
  ["01111", "01010"]

  iex> Day03.filter_by_commonality(["01111", "01010"], &Day03.least_common/2, 2)
  ["01010"]
  """
  def filter_by_commonality(list, comp_func, position) do
    zero_count = Enum.count(list, fn string -> String.at(string, position) == "0" end)
    one_count = length(list) - zero_count
    preferred_value = comp_func.(zero_count, one_count)

    Enum.filter(list, fn item -> String.at(item, position) == preferred_value end)
  end

  defp gamma_rate(input) do
    input
    |> Enum.map(&String.to_charlist/1)
    |> Advent.transpose()
    |> Enum.map(&most_common_value/1)
    |> List.to_string()
    |> String.to_integer(2)
  end

  defp epsilon_rate(input, gamma) do
    # The inverse binary value, eg. the maximum binary value that can be encoded minus the gamma value.
    max = :math.pow(2, String.length(hd(input))) |> round
    max - gamma - 1
  end

  defp most_common_value(string) do
    string
    |> Enum.frequencies()
    |> Enum.max_by(fn {_num, val} -> val end)
    |> then(fn {num, _val} -> num end)
  end

  def part1_verify, do: input() |> String.split("\n") |> part1() |> elem(2)
  def part2_verify, do: input() |> String.split("\n") |> part2() |> elem(2)
end

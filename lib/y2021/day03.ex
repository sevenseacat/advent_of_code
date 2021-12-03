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

  defp gamma_rate(input) do
    input = Enum.map(input, &String.graphemes/1)
    max = length(input)

    0..(length(hd(input)) - 1)
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

  defp most_common_value(lists, position, max_value) do
    count_ones(lists, position) |> to_binary_value(max_value)
  end

  defp count_ones(lists, position) do
    Enum.count(lists, fn item -> Enum.at(item, position) == "1" end)
  end

  defp to_binary_value(value, max) when value * 2 > max, do: "1"
  defp to_binary_value(_, _), do: "0"

  def part1_verify, do: input() |> String.split("\n") |> part1() |> elem(2)
end

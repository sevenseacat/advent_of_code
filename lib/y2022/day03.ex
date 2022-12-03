defmodule Y2022.Day03 do
  use Advent.Day, no: 03

  def part1(input) do
    input
    |> Enum.map(fn string ->
      halves = String.split_at(string, div(String.length(string), 2)) |> Tuple.to_list()
      common_priority(halves).value
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Enum.chunk_every(3)
    |> Enum.map(fn rucksacks -> common_priority(rucksacks).value end)
    |> Enum.sum()
  end

  @doc """
  iex> Day03.common_priority(["vJrwpWtwJgWr", "hcsFMMfFFhFp"])
  %{item: "p", value: 16}

  iex> Day03.common_priority(["jqHRNqRjqzjGDLGL", "rsFMfFZSrLrFZsSL"])
  %{item: "L", value: 38}
  """
  def common_priority(lists) do
    common_item =
      lists
      |> Enum.map(&String.to_charlist/1)
      |> common_elements()
      |> hd()

    # 38 is ?A - priority of "A" (27), 96 is ?a - priority of "a" (1)
    value = if common_item in ?A..?Z, do: common_item - 38, else: common_item - 96
    %{item: to_string([common_item]), value: value}
  end

  defp common_elements([a, b]), do: a -- a -- b
  defp common_elements([a, b | rest]), do: common_elements([a, common_elements([b | rest])])

  def parse_input(input) do
    String.split(input, "\n", trim: true)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

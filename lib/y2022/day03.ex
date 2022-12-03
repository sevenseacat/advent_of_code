defmodule Y2022.Day03 do
  use Advent.Day, no: 03

  def part1(input) do
    input
    |> Enum.map(fn rucksack -> common_priority(rucksack).value end)
    |> Enum.sum()
  end

  @doc """
  iex> Day03.common_priority({"vJrwpWtwJgWr", "hcsFMMfFFhFp"})
  %{item: "p", value: 16}

  iex> Day03.common_priority({"jqHRNqRjqzjGDLGL", "rsFMfFZSrLrFZsSL"})
  %{item: "L", value: 38}
  """
  def common_priority({a, b}) do
    list_a = String.to_charlist(a)
    list_b = String.to_charlist(b)
    common_item = hd(list_a -- list_a -- list_b)

    # 38 is ?A - priority of "A" (27), 96 is ?a - priority of "a" (1)
    value = if common_item in ?A..?Z, do: common_item - 38, else: common_item - 96
    %{item: to_string([common_item]), value: value}
  end

  @doc """
  iex> Day03.parse_input("vJrwpWtwJgWrhcsFMMfFFhFp\\njqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL")
  [{"vJrwpWtwJgWr", "hcsFMMfFFhFp"}, {"jqHRNqRjqzjGDLGL", "rsFMfFZSrLrFZsSL"}]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn string -> String.split_at(string, div(String.length(string), 2)) end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
end

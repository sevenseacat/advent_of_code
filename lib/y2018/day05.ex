defmodule Y2018.Day05 do
  use Advent.Day, no: 5

  @doc """
  iex> Day05.part1("aA")
  ""

  iex> Day05.part1("abBA")
  ""

  iex> Day05.part1("abAB")
  "abAB"

  iex> Day05.part1("aabAAB")
  "aabAAB"

  iex> Day05.part1("dabAcCaCBAcCcaDA")
  "dabCBAcaDA"

  iex> Day05.part1("dabAcCaCBAcCcadDAC")
  "dabCBA"
  """
  def part1(input) do
    input
    |> String.trim()
    |> String.graphemes()
    |> dedup(1)
    |> List.to_string()
  end

  def dedup([], _), do: []
  def dedup([x], _), do: [x]

  def dedup(list, index) when index == length(list), do: list

  def dedup(list, index) do
    a = Enum.at(list, index - 1)
    b = Enum.at(list, index)

    if a != b && String.downcase(a) == String.downcase(b) do
      new_list = delete_at(list, index - 1)
      dedup(new_list, index - 1)
    else
      dedup(list, index + 1)
    end
  end

  def delete_at(list, index) do
    list
    |> List.delete_at(index)
    |> List.delete_at(index)
  end

  def part1_verify, do: input() |> part1() |> String.length()
end

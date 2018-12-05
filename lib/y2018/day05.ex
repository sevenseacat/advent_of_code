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

  @doc """
  iex> Day05.part2("dabAcCaCBAcCcaDA")
  {"c", 4}
  """
  def part2(input) do
    input = String.trim(input)
    input_list = String.graphemes(input)

    input
    |> String.downcase()
    |> String.graphemes()
    |> Enum.uniq()
    |> Enum.map(fn char ->
      {char, remove_letter_and_dedup(input_list, char) |> length}
    end)
    |> Enum.min_by(fn {_, result} -> result end)
  end

  @doc """
  iex> Day05.remove_letter_and_dedup(String.graphemes("dabAcCaCBAcCcaDA"), "a") |> List.to_string
  "dbCBcD"

  iex> Day05.remove_letter_and_dedup(String.graphemes("dabAcCaCBAcCcaDA"), "b") |> List.to_string
  "daCAcaDA"

  iex> Day05.remove_letter_and_dedup(String.graphemes("dabAcCaCBAcCcaDA"), "c") |> List.to_string
  "daDA"

  iex> Day05.remove_letter_and_dedup(String.graphemes("dabAcCaCBAcCcaDA"), "d") |> List.to_string
  "abCBAc"
  """
  def remove_letter_and_dedup(list, char) do
    list
    |> Enum.reject(&(&1 == char || &1 == String.upcase(char)))
    |> dedup(1)
  end

  defp dedup([], _), do: []
  defp dedup([x], _), do: [x]
  defp dedup(list, index) when index == length(list), do: list

  defp dedup(list, index) do
    a = Enum.at(list, index - 1)
    b = Enum.at(list, index)

    if a != b && String.downcase(a) == String.downcase(b) do
      new_list = delete_at(list, index - 1)
      dedup(new_list, index - 1)
    else
      dedup(list, index + 1)
    end
  end

  defp delete_at(list, index) do
    list
    |> List.delete_at(index)
    |> List.delete_at(index)
  end

  def part1_verify, do: input() |> part1() |> String.length()
  def part2_verify, do: input() |> part2() |> elem(1)
end

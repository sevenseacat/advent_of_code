defmodule Y2023.Day04 do
  use Advent.Day, no: 04

  def part1(input) do
    input
    |> Enum.map(&points_for_card/1)
    |> Enum.reduce(0, fn
      0, acc -> acc
      num, acc -> acc + Integer.pow(2, num - 1)
    end)
  end

  # @doc """
  # iex> Day04.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp points_for_card(card) do
    Advent.common_elements([card.winning, card.yours])
    |> length
  end

  @doc """
  iex> Day04.parse_input("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53")
  [%{number: 1, winning: [41, 48, 83, 86, 17], yours: [83, 86, 6, 31, 17, 9, 48, 53]}]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(row) do
    [card_no, winning, yours] = String.split(row, [":", "|"])
    number = String.replace(card_no, "Card", "") |> String.trim() |> String.to_integer()

    %{number: number, winning: parse_numbers(winning), yours: parse_numbers(yours)}
  end

  defp parse_numbers(numbers) do
    numbers
    |> String.split(~r/\s+/)
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end

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

  def part2(input) do
    input
    |> calculate_winnings()
    |> run_game(initial(input), 1, length(input))
  end

  defp points_for_card(card) do
    Advent.common_elements([card.winning, card.yours])
    |> length
  end

  defp calculate_winnings(input) do
    input
    |> Enum.reduce(%{}, fn game, acc ->
      Map.put(acc, game.number, points_for_card(game))
    end)
  end

  defp initial(input) do
    Enum.reduce(input, %{}, &Map.put(&2, &1.number, 1))
  end

  defp run_game(_input, all_cards, current, max) when current >= max do
    all_cards
    |> Map.values()
    |> Enum.sum()
  end

  defp run_game(input, all_cards, current, max) do
    held = Map.fetch!(all_cards, current)
    winning = Map.fetch!(input, current)

    # IO.puts("Picked card #{current}, win #{held} for each of the next #{winning}!")

    all_cards =
      case winning do
        0 -> all_cards
        num -> add_winnings(all_cards, current, held, num)
      end

    run_game(input, all_cards, current + 1, max)
  end

  defp add_winnings(cards, current, held, count) do
    1..count
    |> Enum.reduce(cards, fn offset, acc ->
      Map.update!(acc, offset + current, &(&1 + held))
    end)
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
  def part2_verify, do: input() |> parse_input() |> part2()
end

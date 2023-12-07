defmodule Y2023.Day07 do
  use Advent.Day, no: 07

  @hand_order [
    :high_card,
    :one_pair,
    :two_pair,
    :three_of_a_kind,
    :full_house,
    :four_of_a_kind,
    :five_of_a_kind
  ]

  @card_order ~w(2 3 4 5 6 7 8 9 T J Q K A)
  @joker_card_order ~w(J 2 3 4 5 6 7 8 9 T Q K A)

  def part1(input) do
    input
    |> Enum.sort_by(&hand_strength/1)
    |> Enum.with_index()
    |> Enum.reduce(0, fn {%{bid: bid}, index}, acc ->
      acc + (index + 1) * bid
    end)
  end

  def part2(input) do
    input
    |> Enum.map(&joker_replacement/1)
    |> Enum.sort_by(&elem(&1, 1))
    |> Enum.with_index()
    |> Enum.reduce(0, fn {{%{bid: bid}, _strength}, index}, acc ->
      acc + (index + 1) * bid
    end)
  end

  @doc """
  iex> Day07.parse_input("32T3K 765\\nT55J5 684")
  [%{cards: ["3", "2", "T", "3", "K"], bid: 765, type: :one_pair},
   %{cards: ["T", "5", "5", "J", "5"], bid: 684, type: :three_of_a_kind}]
  """
  def parse_input(input) do
    for row <- String.split(input, "\n", trim: true) do
      [cards, bid] = String.split(row, " ")
      cards = String.graphemes(cards)

      %{
        cards: cards,
        bid: String.to_integer(bid),
        type: hand_type(cards)
      }
    end
  end

  defp hand_strength(%{cards: cards, type: type}, order \\ @card_order) do
    [Enum.find_index(@hand_order, &(&1 == type)) | Enum.map(cards, &card_strength(&1, order))]
  end

  defp joker_replacement(%{cards: cards} = hand) do
    if "J" in cards do
      @joker_card_order
      |> Enum.map(fn card ->
        cards = replace(cards, {"J", card})
        hand = Map.put(hand, :type, hand_type(cards))

        {hand, hand_strength(hand, @joker_card_order)}
      end)
      |> Enum.max_by(&elem(&1, 1))
    else
      {hand, hand_strength(hand, @joker_card_order)}
    end
  end

  defp replace([], _), do: []
  defp replace([from | rest], {from, to}), do: [to | replace(rest, {from, to})]
  defp replace([card | rest], {from, to}), do: [card | replace(rest, {from, to})]

  defp card_strength(card, order) do
    Enum.find_index(order, &(&1 == card))
  end

  defp hand_type(cards) do
    frequencies = cards |> Enum.frequencies() |> Map.values() |> Enum.sort_by(&(-&1))

    case frequencies do
      [5] -> :five_of_a_kind
      [4, 1] -> :four_of_a_kind
      [3, 2] -> :full_house
      [2, 2, 1] -> :two_pair
      [3 | _] -> :three_of_a_kind
      [2 | _] -> :one_pair
      _ -> :high_card
    end
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

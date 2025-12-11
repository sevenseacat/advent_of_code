defmodule Y2020.Day22 do
  use Advent.Day, no: 22

  @doc """
  iex> Day22.part1({[9, 2, 6, 3, 1], [5, 8, 4, 7, 10]})
  {[3, 2, 10, 6, 8, 5, 9, 4, 7, 1], 306}
  """
  def part1({one, two}) do
    result = play_game(one, two)
    {result, calculate_score(result)}
  end

  # @doc """
  # iex> Day22.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp calculate_score(result) do
    result
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {num, index}, acc -> acc + num * index end)
  end

  defp play_game(as, []), do: as
  defp play_game([], bs), do: bs

  defp play_game([a | as], [b | bs]) do
    cond do
      b > a -> play_game(as, bs ++ [b, a])
      a > b -> play_game(as ++ [a, b], bs)
      true -> raise "should not happen!"
    end
  end

  def parse_input(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_hand/1)
    |> List.to_tuple()
  end

  defp parse_hand(hand) do
    hand
    |> String.split("\n", trim: true)
    |> tl()
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input() |> part1() |> elem(1)
  # def part2_verify, do: input() |> parse_input() |> part2()
end

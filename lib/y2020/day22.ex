defmodule Y2020.Day22 do
  use Advent.Day, no: 22

  @doc """
  iex> Day22.part1({[9, 2, 6, 3, 1], [5, 8, 4, 7, 10]})
  {[3, 2, 10, 6, 8, 5, 9, 4, 7, 1], 306}
  """
  def part1({one, two}) do
    result = play_standard_game(one, two)
    {result, calculate_score(result)}
  end

  @doc """
  iex> Day22.part2({[9, 2, 6, 3, 1], [5, 8, 4, 7, 10]})
  {[7, 5, 6, 2, 4, 1, 10, 8, 9, 3], 291}
  """
  def part2({one, two}) do
    {_winner, result} = play_recursive_game(one, two, MapSet.new(), 1)
    {result, calculate_score(result)}
  end

  defp calculate_score(result) do
    result
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {num, index}, acc -> acc + num * index end)
  end

  defp play_standard_game(as, []), do: as
  defp play_standard_game([], bs), do: bs

  defp play_standard_game([a | as], [b | bs]) do
    cond do
      b > a -> play_standard_game(as, bs ++ [b, a])
      a > b -> play_standard_game(as ++ [a, b], bs)
      true -> raise "should not happen!"
    end
  end

  defp play_recursive_game(as, [], _seen, _game), do: {:a, as}
  defp play_recursive_game([], bs, _seen, _game), do: {:b, bs}

  defp play_recursive_game([a | as] = all_a, [b | bs] = all_b, seen, game) do
    if MapSet.member?(seen, {all_a, all_b}) do
      {:a, as}
    else
      winner =
        cond do
          length(as) >= a && length(bs) >= b ->
            clone_as = Enum.take(as, a)
            clone_bs = Enum.take(bs, b)

            play_recursive_game(clone_as, clone_bs, MapSet.new(), game + 1)
            |> elem(0)

          b > a ->
            :b

          a > b ->
            :a

          true ->
            raise "should not happen!"
        end

      seen = MapSet.put(seen, {all_a, all_b})

      if winner == :a do
        play_recursive_game(as ++ [a, b], bs, seen, game)
      else
        play_recursive_game(as, bs ++ [b, a], seen, game)
      end
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
  def part2_verify, do: input() |> parse_input() |> part2() |> elem(1)
end

defmodule Y2018.Day09 do
  use Advent.Day, no: 9

  @doc """
  iex> Day09.part1("9 players; last marble is worth 25 points")
  32

  iex> Day09.part1("10 players; last marble is worth 1618 points")
  8317

  iex> Day09.part1("13 players; last marble is worth 7999 points")
  146373

  iex> Day09.part1("17 players; last marble is worth 1104 points")
  2764

  iex> Day09.part1("21 players; last marble is worth 6111 points")
  54718

  iex> Day09.part1("30 players; last marble is worth 5807 points")
  37305
  """
  def part1(input) do
    {players, points} = parse_input(input)

    run_game(%{
      scores: %{},
      players: players,
      turn: 1,
      current: 1,
      max: points,
      field: {[0], []}
    })
    |> Map.get(:scores)
    |> Enum.max_by(fn {_player, score} -> score end)
    |> elem(1)
  end

  defp run_game(%{current: marble, max: max} = game) when marble > max, do: game

  defp run_game(%{
         players: players,
         turn: turn,
         current: curr,
         field: field,
         scores: scores,
         max: max
       }) do
    {score, field} = place_marble(field, curr)

    run_game(%{
      players: players,
      turn: rem(turn + 1, players),
      current: curr + 1,
      field: field,
      scores: Map.update(scores, turn, score, &(&1 + score)),
      max: max
    })
  end

  defp place_marble(state, new) do
    if rem(new, 23) == 0 do
      {fwd, bwd} =
        Enum.reduce(1..7, state, fn _, state ->
          move_marble_back(state)
        end)

      {new + hd(bwd), {tl(fwd), [hd(fwd) | tl(bwd)]}}
    else
      {fwd, bwd} = move_marble_forward(state)
      {0, {fwd, [new | bwd]}}
    end
  end

  defp move_marble_back({fwd, []}), do: move_marble_back({[], Enum.reverse(fwd)})
  defp move_marble_back({fwd, [hd | bwd]}), do: {[hd | fwd], bwd}

  defp move_marble_forward({[], bwd}), do: move_marble_forward({Enum.reverse(bwd), []})
  defp move_marble_forward({[hd | fwd], bwd}), do: {fwd, [hd | bwd]}

  defp parse_input(input) do
    ~r/(\d+) players; last marble is worth (\d+) points/
    |> Regex.run(input, capture: :all_but_first)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def part1_verify, do: part1("429 players; last marble is worth 70901 points")
  def part2_verify, do: part1("429 players; last marble is worth 7090100 points")
end

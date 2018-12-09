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
      turn: 0,
      current: 1,
      last: 0,
      max: points,
      field: [0]
    })
    |> Map.get(:scores)
    |> Enum.max_by(fn {_player, score} -> score end)
    |> elem(1)
  end

  defp run_game(%{current: marble, max: max} = game) when marble > max, do: game

  defp run_game(
         %{
           players: players,
           turn: turn,
           current: curr,
           last: last,
           field: field
         } = game
       ) do
    {score, new_pos, field} = place_marble(field, curr, last)

    game =
      game
      |> Map.put(:last, new_pos)
      |> Map.put(:field, field)
      |> Map.update!(:scores, fn old_score ->
        Map.update(old_score, turn, score, &(&1 + score))
      end)

    # IO.inspect(game)

    Map.put(game, :current, curr + 1)
    |> Map.put(:turn, rem(turn + 1, players))
    |> run_game
  end

  @doc """
  iex> Day09.place_marble([0], 1, 0)
  {0, 1, [0, 1]}

  iex> Day09.place_marble([0, 1], 2, 1)
  {0, 1, [0, 2, 1]}

  iex> Day09.place_marble([0, 2, 1], 3, 1)
  {0, 3, [0, 2, 1, 3]}

  iex> Day09.place_marble([0, 16, 8, 17, 4, 18, 9, 19, 2, 20, 10, 21, 5, 22, 11, 1, 12, 6, 13, 3, 14, 7, 15],
  ...> 23, 13)
  {32, 6, [0, 16, 8, 17, 4, 18, 19, 2, 20, 10, 21, 5, 22, 11, 1, 12, 6, 13, 3, 14, 7, 15]}
  """
  def place_marble(field, points, last) do
    if rem(points, 23) == 0 do
      new_index = new_special_position(length(field), last)
      {replaced, list} = List.pop_at(field, new_index)
      {points + replaced, new_index, list}
    else
      new_index = new_normal_position(length(field), last)
      {0, new_index, List.insert_at(field, new_index, points)}
    end
  end

  def new_special_position(size, pos) do
    if pos - 7 >= 0, do: pos - 7, else: pos - 7 + size
  end

  def new_normal_position(size, pos) do
    if pos + 2 > size, do: pos + 2 - size, else: pos + 2
  end

  defp parse_input(input) do
    ~r/(\d+) players; last marble is worth (\d+) points/
    |> Regex.run(input, capture: :all_but_first)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def part1_verify, do: part1("429 players; last marble is worth 70901 points")
end

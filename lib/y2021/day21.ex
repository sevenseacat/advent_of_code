defmodule Y2021.Day21 do
  use Advent.Day, no: 21

  @p1_start 4
  @p2_start 7
  @winning_score 1000

  @doc """
  iex> Day21.part1(4, 8)
  739785
  """
  def part1(p1_start \\ @p1_start, p2_start \\ @p2_start) do
    state = %{
      p1_position: p1_start,
      p1_score: 0,
      p2_position: p2_start,
      p2_score: 0,
      last_roll: 0
    }

    {state, winner} = play_game(state, :p1)
    losing_score(state, winner) * state.last_roll
  end

  defp play_game(%{p1_score: p1_score} = state, _turn) when p1_score >= @winning_score,
    do: {state, :p1}

  defp play_game(%{p2_score: p2_score} = state, _turn) when p2_score >= @winning_score,
    do: {state, :p2}

  defp play_game(%{last_roll: roll} = state, turn) do
    moves = Enum.sum([roll + 1, roll + 2, roll + 3])

    {roller_position, roller_score, next_turn} = get_roller(turn)

    new_position = move_pawn(Map.get(state, roller_position) + moves)
    new_score = Map.get(state, roller_score) + new_position

    play_game(
      %{state | roller_position => new_position, roller_score => new_score, last_roll: roll + 3},
      next_turn
    )
  end

  @doc """
  iex> Day21.move_pawn(10)
  10

  iex> Day21.move_pawn(20)
  10

  iex> Day21.move_pawn(25)
  5
  """
  def move_pawn(position) when position <= 10, do: position

  def move_pawn(position) do
    mod = rem(position, 10)
    if mod == 0, do: 10, else: mod
  end

  defp losing_score(%{p2_score: score}, :p1), do: score
  defp losing_score(%{p1_score: score}, :p2), do: score

  defp get_roller(:p1), do: {:p1_position, :p1_score, :p2}
  defp get_roller(:p2), do: {:p2_position, :p2_score, :p1}

  def part1_verify, do: part1()
end

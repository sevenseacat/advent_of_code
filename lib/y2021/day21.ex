defmodule Y2021.Day21 do
  use Advent.Day, no: 21

  @p1_start 4
  @p2_start 7

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

    {state, winner} = play_p1_game(state, :p1)
    losing_score(state, winner) * state.last_roll
  end

  defp play_p1_game(%{p1_score: p1_score} = state, _turn) when p1_score >= 1000,
    do: {state, :p1}

  defp play_p1_game(%{p2_score: p2_score} = state, _turn) when p2_score >= 1000,
    do: {state, :p2}

  defp play_p1_game(%{last_roll: roll} = state, turn) do
    moves = Enum.sum([roll + 1, roll + 2, roll + 3])

    {roller_position, roller_score, next_turn} = get_roller(turn)

    new_position = move_pawn(Map.get(state, roller_position) + moves)
    new_score = Map.get(state, roller_score) + new_position

    play_p1_game(
      %{state | roller_position => new_position, roller_score => new_score, last_roll: roll + 3},
      next_turn
    )
  end

  @doc """
  iex> Day21.part2(4, 8)
  {444_356_092_776_315, 341_960_390_180_808}
  """
  def part2(p1_start \\ @p1_start, p2_start \\ @p2_start) do
    state = %{
      p1_position: p1_start,
      p1_score: 0,
      p2_position: p2_start,
      p2_score: 0,
      outcomes: 1,
      turn: :p1
    }

    play_p2_game([state], {0, 0})
  end

  def play_p2_game([], outcomes), do: outcomes

  def play_p2_game([state | states], {p1_wins, p2_wins} = outcomes) do
    # IO.puts("------------------")
    # IO.inspect([state | states])
    # :timer.sleep(1000)

    {outcomes, new_states} =
      case take_p2_turn(state) do
        {:p1, outcomes} -> {{p1_wins + outcomes, p2_wins}, []}
        {:p2, outcomes} -> {{p1_wins, p2_wins + outcomes}, []}
        new_states when is_list(new_states) -> {outcomes, new_states}
      end

    play_p2_game(new_states ++ states, outcomes)
  end

  @doc """
  iex> Day21.take_p2_turn(%{p1_position: 4, p1_score: 2, p2_position: 3, p2_score: 4, outcomes: 6, turn: :p1})
  [
    %{p1_position: 7, p1_score: 9, p2_position: 3, p2_score: 4, outcomes: 6, turn: :p2},
    %{p1_position: 8, p1_score: 10, p2_position: 3, p2_score: 4, outcomes: 18, turn: :p2},
    %{p1_position: 9, p1_score: 11, p2_position: 3, p2_score: 4, outcomes: 36, turn: :p2},
    %{p1_position: 10, p1_score: 12, p2_position: 3, p2_score: 4, outcomes: 42, turn: :p2},
    %{p1_position: 1, p1_score: 3, p2_position: 3, p2_score: 4, outcomes: 36, turn: :p2},
    %{p1_position: 2, p1_score: 4, p2_position: 3, p2_score: 4, outcomes: 18, turn: :p2},
    %{p1_position: 3, p1_score: 5, p2_position: 3, p2_score: 4, outcomes: 6, turn: :p2}
  ]

  iex> Day21.take_p2_turn(%{p1_position: 4, p1_score: 2, p2_position: 3, p2_score: 21, outcomes: 6, turn: :p2})
  {:p2, 6}
  """
  def take_p2_turn(%{p1_score: p1_score, outcomes: outcomes})
      when p1_score >= 21 do
    {:p1, outcomes}
  end

  def take_p2_turn(%{p2_score: p2_score, outcomes: outcomes})
      when p2_score >= 21 do
    {:p2, outcomes}
  end

  def take_p2_turn(state) do
    # Each turn the total rolls can be:
    # 3 -> [1,1,1] - 1 option
    # 4 -> [1,1,2], [1,2,1], [2,1,1] - 3 options
    # 5 -> [1,1,3], [1,2,2], [1,3,1], [2,1,2], [2,2,1], [3,1,1] - 6 options
    # 6 -> [1,2,3], [1,3,2], [2,1,3], [2,2,2], [2,3,1], [3,1,2], [3,2,1] - 7 options
    # 7 -> [1,3,3], [2,2,3], [2,3,2], [3,1,3], [3,2,2], [3,3,1] - 6 options
    # 8 -> [2,3,3], [3,2,3], [3,3,2] - 3 options
    # 9 -> [3,3,3] - 1 option
    # So the universe splits into 6, each representing a number of potential outcomes.
    # Don't need to simulate all 45 bajillion outcomes.

    {roller_position, roller_score, next_turn} = get_roller(state.turn)

    [{3, 1}, {4, 3}, {5, 6}, {6, 7}, {7, 6}, {8, 3}, {9, 1}]
    |> Enum.map(fn {move, outcomes} ->
      new_position = move_pawn(Map.get(state, roller_position) + move)
      new_score = Map.get(state, roller_score) + new_position

      %{
        state
        | roller_position => new_position,
          roller_score => new_score,
          outcomes: state.outcomes * outcomes,
          turn: next_turn
      }
    end)
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
  def part2_verify, do: part2() |> elem(0)
end

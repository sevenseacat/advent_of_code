defmodule Y2016.Day11 do
  use Advent.Day, no: 11

  alias Y2016.Day11.State

  def part1(input) do
    input
    |> get_optimal_path
    |> length
  end

  def part2(input) do
    input
    |> State.add_components(1, [:dilithium, :elerium])
    |> get_optimal_path
    |> length
  end

  @doc """
  This is the actual breadth-first search part. ie. the point of the puzzle.
  """
  def get_optimal_path(state) do
    do_search([{[], State.legal_moves(state)}], [], MapSet.new())
  end

  # Reached the end of a level. Start going through allll the states on the next level.
  defp do_search([], next_level_states, all_seen_states) do
    # IO.puts(
    #   "* Level #{next_level_states |> hd |> elem(0) |> length}: #{length(next_level_states)} states to check."
    # )

    do_search(next_level_states, [], all_seen_states)
  end

  # We've exhausted one state's possible next states - move onto the next state to expand.
  defp do_search([{_path, []} | alt_paths], next_level_states, all_seen_states) do
    do_search(alt_paths, next_level_states, all_seen_states)
  end

  # The main function head - checking all legal moves associated with a given state.
  # If the state doesn't win, expand out it's legal moves, shove them on a stack, and keep looking.
  defp do_search([{path, [state | states]} | alt_paths], next_level_states, all_seen_states) do
    if State.winning?(state) do
      # Jackpot!
      Enum.reverse([state | path])
    else
      # Avoid cycles by only using this computed state if it is not already in the path taken to get to this state.
      # Also drastically cut down on the number of states in memory, by recording *all* states
      # we've seen - if we see a state twice, the earlier one was clearly more optimal so disregard future references to it.
      if MapSet.member?(all_seen_states, state) do
        do_search([{path, states} | alt_paths], next_level_states, all_seen_states)
      else
        do_search(
          [{path, states} | alt_paths],
          [{[state | path], State.legal_moves(state)} | next_level_states],
          MapSet.put(all_seen_states, state)
        )
      end
    end
  end

  def parse_input(input) do
    input
    |> Code.eval_string()
    |> elem(0)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

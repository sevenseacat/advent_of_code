defmodule Y2016.Day11 do
  use Advent.Day, no: 11

  alias Y2016.Day11.State

  def part1 do
    State.initial()
    |> get_optimal_path
    |> length
  end

  @doc """
  This is the actual breadth-first search part. ie. the point of the puzzle.
  """
  def get_optimal_path(state) do
    do_search([{[], State.legal_moves(state)}], [])
  end

  def do_search([], next_level_states) do
    IO.puts(
      "* Going to level #{next_level_states |> hd |> elem(0) |> length}: #{length(next_level_states)} states to check in this level."
    )

    do_search(next_level_states, [])
  end

  def do_search([{_path, []} | alt_paths], next_level_states),
    do: do_search(alt_paths, next_level_states)

  def do_search([{path, [state | states]} | alt_paths], next_level_states) do
    case State.winning?(state) do
      true ->
        Enum.reverse([state | path])

      false ->
        # Avoid cycles by only using this computed state if it is not already in the path.
        case state in path do
          true ->
            do_search([{path, states} | alt_paths], next_level_states)

          false ->
            do_search([{path, states} | alt_paths], [
              {[state | path], State.legal_moves(state)} | next_level_states
            ])
        end
    end
  end
end

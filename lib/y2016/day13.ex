defmodule Y2016.Day13 do
  use Advent.Day, no: 13

  # This is almost a carbon-copy of day 11, with a much simpler state (now just a position).
  alias Y2016.Day13.Position

  def part1 do
    Position.initial()
    |> get_optimal_path([31, 39], 1362)
    |> length
  end

  @doc """
  This is the actual breadth-first search part. ie. the point of the puzzle.
  """
  def get_optimal_path(initial, destination, magic_number) do
    do_search(
      [{[], Position.legal_moves(initial, magic_number)}],
      [],
      destination,
      magic_number,
      %{}
    )
  end

  # Reached the end of a level. Start going through allll the positions on the next level.
  defp do_search([], next_level, destination, magic_number, visited) do
    IO.puts(
      "* Level #{next_level |> hd |> elem(0) |> length}: #{length(next_level)} positions to check."
    )

    do_search(next_level, [], destination, magic_number, visited)
  end

  # We've exhausted one position's possible next positions - move onto the next position to expand.
  defp do_search([{_path, []} | alt_paths], next_level, destination, magic_number, visited) do
    do_search(alt_paths, next_level, destination, magic_number, visited)
  end

  # The main function head - checking all legal moves associated with a given position.
  # If the position doesn't win, expand out it's legal moves, shove them on a stack, and keep looking.
  defp do_search(
         [{path, [position | positions]} | alt_paths],
         next_level,
         destination,
         magic_number,
         visited
       ) do
    case Position.winning?(position, destination) do
      # Jackpot!
      true ->
        Enum.reverse([position | path])

      false ->
        # Drastically cut down on the number of positions in memory, by recording *all* visited positions
        # If we see a position twice, the earlier one was clearly more optimal so disregard future references to it.
        case Map.get(visited, position, false) do
          true ->
            do_search(
              [{path, positions} | alt_paths],
              next_level,
              destination,
              magic_number,
              visited
            )

          false ->
            visited = Map.put(visited, position, true)

            do_search(
              [{path, positions} | alt_paths],
              [{[position | path], Position.legal_moves(position, magic_number)} | next_level],
              destination,
              magic_number,
              visited
            )
        end
    end
  end

  def part1_verify, do: part1()
end

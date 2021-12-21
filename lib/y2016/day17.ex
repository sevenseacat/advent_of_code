defmodule Y2016.Day17 do
  use Advent.Day, no: 17

  @puzzle_input "pvhmgsws"
  @size 4

  @doc """
  iex> Day17.part1("ihgpwlah")
  "DDRRRD"

  iex> Day17.part1("kglvqrro")
  "DDUDRLRRUDRD"

  iex> Day17.part1("ulqzkmiv")
  "DRURDRUDDLLDLUURRDULRLDUUDDDRR"
  """
  def part1(input) do
    get_path(input, :shortest)
    |> String.replace_leading(input, "")
  end

  @doc """
  iex> Day17.part2("ihgpwlah")
  370

  iex> Day17.part2("kglvqrro")
  492

  iex> Day17.part2("ulqzkmiv")
  830
  """
  def part2(input) do
    get_path(input, :longest)
    |> String.replace_leading(input, "")
    |> String.length()
  end

  @doc """
  This is the actual breadth-first search part. ie. the point of the puzzle.
  """
  def get_path(input, path_type) do
    do_search(next_moves({0, 0, input}), [], nil, path_type)
  end

  defp do_search([], [], last_path, :longest), do: last_path

  defp do_search([], [], _level, :shortest) do
    raise("Something went terribly wrong and we did not find a solution")
  end

  # Reached the end of a level. Start going through allll the states on the next level.
  defp do_search([], next_level, last_path, path_type) do
    # IO.puts(
    #  "* Level #{next_level |> hd |> elem(2) |> String.length()}: #{length(next_level)} states to check."
    # )

    do_search(next_level, [], last_path, path_type)
  end

  # The main function head - checking all legal moves associated with a given state.
  # If the state doesn't win, expand out it's legal moves, shove them on a stack, and keep looking.
  defp do_search([{x, y, path} = state | states], next_level, _last_path, :shortest) do
    if winning?({x, y}) do
      # Jackpot!
      path
    else
      do_search(
        states,
        next_moves(state) ++ next_level,
        nil,
        :shortest
      )
    end
  end

  defp do_search([{x, y, path} = state | states], next_level, last_path, :longest) do
    {new_path, next_level} =
      if winning?({x, y}) do
        {path, next_level}
      else
        {last_path, next_moves(state) ++ next_level}
      end

    do_search(states, next_level, new_path, :longest)
  end

  defp winning?({x, y}), do: x == @size - 1 && y == @size - 1

  defp next_moves({x, y, string}) do
    md5 = :erlang.md5(string) |> Base.encode16()

    [
      [{x, y - 1, "#{string}U"}, 0],
      [{x, y + 1, "#{string}D"}, 1],
      [{x - 1, y, "#{string}L"}, 2],
      [{x + 1, y, "#{string}R"}, 3]
    ]
    |> Enum.filter(fn [{x, y, _path}, offset] ->
      in_grid?({x, y}) && open?(md5, offset)
    end)
    |> Enum.map(&hd/1)
  end

  defp in_grid?({x, y}), do: x in 0..(@size - 1) && y in 0..(@size - 1)

  defp open?(md5, offset), do: String.at(md5, offset) in ["B", "C", "D", "E", "F"]

  def part1_verify, do: part1(@puzzle_input)
  def part2_verify, do: part2(@puzzle_input)
end

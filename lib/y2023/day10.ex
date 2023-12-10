defmodule Y2023.Day10 do
  use Advent.Day, no: 10

  def part1({_raw, graph, start}) do
    path = find_path(graph, start)
    div(length(path), 4)
  end

  def part2({raw, graph, start}) do
    path = find_path(graph, start)
    vertices = Graph.vertices(graph)

    # Filter out all non-path pipes, so we're left with a map of %{coord => pipe_type}
    # This includes replacing the S with the type of pipe it actually is
    input =
      raw
      |> raw_input()
      |> Enum.filter(fn {coord, _char} -> coord in path end)
      |> Enum.into(%{})
      |> Map.put(start, start_pipe(path))

    {max_row, _} = vertices |> Enum.max_by(&elem(&1, 0))
    max_row = ceil(max_row)
    {_, max_col} = vertices |> Enum.max_by(&elem(&1, 1))
    max_col = ceil(max_col)

    for row <- 1..max_row,
        col <- 1..max_col,
        within_path?(input, path, {row, col}, {max_row, max_col}) do
      {row, col}
    end
    |> length
  end

  defp find_path(graph, {row, col}) do
    # We know the animal position - the pipe at S is actually one of the other
    # letters so we could actually be starting at the square above, below, left
    # right of the start, and trying to get back to the start
    path =
      [{row - 0.5, col}, {row + 0.5, col}, {row, col - 0.5}, {row, col + 0.5}]
      |> Enum.flat_map(fn position ->
        # Find the path from the new start back to the original position
        [
          Graph.dijkstra(graph, position, {row - 0.5, col}),
          Graph.dijkstra(graph, position, {row + 0.5, col}),
          Graph.dijkstra(graph, position, {row, col - 0.5}),
          Graph.dijkstra(graph, position, {row, col + 0.5})
        ]
      end)
      |> Enum.filter(fn path -> path end)
      |> Enum.max_by(fn path -> length(path) end)

    [{row, col} | path]
  end

  defp start_pipe(path) do
    # TODO: Find a way to make this not suck
    {start_row, start_col} = hd(path)
    {next_row, next_col} = Enum.at(path, 1)
    {prev_row, prev_col} = List.last(path)

    case {{start_row - prev_row, start_col - prev_col},
          {next_row - start_row, next_col - start_col}} do
      {{0, 0.5}, {-0.5, 0}} -> "J"
      {{0.5, 0}, {0, -0.5}} -> "J"
      {{0.5, 0}, {0, 0.5}} -> "L"
      {{0, -0.5}, {-0.5, 0}} -> "L"
      {{0, 0.5}, {0.5, 0}} -> "7"
      {{-0.5, 0}, {0, -0.5}} -> "7"
      {{-0.5, 0}, {0, 0.5}} -> "F"
      {{0, -0.5}, {0.5, 0}} -> "F"
    end
  end

  defp within_path?(raw_input, path, {row, col}, {max_row, max_col}) do
    if {row, col} in path do
      false
    else
      # Get the actual list of characters that make up the grid to the left,
      # right, top and bottom of the coord in question
      # There needs to be an odd number of pipes between the coord and the edge of the map
      # Pipes could be simple and straight eg | or - but could be bent
      # eg. -    counts as a single pipe when looking from above/below the |
      #      |
      #       -
      #
      #    |       is a single pipe when looking right from X
      # x   ---
      #        |
      # So regex over the string is the easiest way here?
      left_row = get_coords(raw_input, row, 0..(col - 1))
      right_row = get_coords(raw_input, row, (col + 1)..max_col)
      up_col = get_coords(raw_input, 0..(row - 1), col)
      down_col = get_coords(raw_input, (row + 1)..max_row, col)

      row_match?(left_row) && row_match?(right_row) && col_match?(up_col) &&
        col_match?(down_col)
    end
  end

  defp get_coords(input, row_range, col_range) do
    row_range = if is_integer(row_range), do: row_range..row_range, else: row_range
    col_range = if is_integer(col_range), do: col_range..col_range, else: col_range

    for row <- row_range, col <- col_range do
      Map.get(input, {row, col}, ".")
    end
    |> Enum.join("")
  end

  defp row_match?(list), do: do_match?(list, ~r/(F-*J|L-*7|\|)/)
  defp col_match?(list), do: do_match?(list, ~r/(7\|*L|F\|*J|\-)/)

  defp do_match?(list, regex) do
    matches =
      Regex.scan(regex, list, capture: :all_but_first)
      |> length()

    rem(matches, 2) != 0
  end

  def raw_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce({%{}, 1}, &raw_row/2)
    |> elem(0)
  end

  defp raw_row(row, {map, row_num}) do
    {map, _col_num} =
      row
      |> String.graphemes()
      |> Enum.reduce({map, 1}, fn char, {map, col_num} ->
        {Map.put_new(map, {row_num, col_num}, char), col_num + 1}
      end)

    {map, row_num + 1}
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index(1)
    |> Enum.reduce({input, Graph.new(), nil}, &parse_row/2)
  end

  defp parse_row({row, row_no}, acc) do
    row
    |> String.graphemes()
    |> Enum.with_index(1)
    |> Enum.reduce(acc, fn {char, col_no}, {input, graph, start} ->
      position = {row_no, col_no}
      joined_to = get_join_positions(char, position)
      start = if char == "S", do: position, else: start

      graph =
        joined_to
        |> Enum.reduce(graph, fn join, graph ->
          graph
          |> Graph.add_edge(join, position)
          |> Graph.add_edge(position, join)
        end)

      {input, graph, start}
    end)
  end

  defp get_join_positions(char, {row, col}) do
    case char do
      "|" -> [{row - 0.5, col}, {row + 0.5, col}]
      "-" -> [{row, col - 0.5}, {row, col + 0.5}]
      "L" -> [{row - 0.5, col}, {row, col + 0.5}]
      "J" -> [{row, col - 0.5}, {row - 0.5, col}]
      "7" -> [{row, col - 0.5}, {row + 0.5, col}]
      "F" -> [{row + 0.5, col}, {row, col + 0.5}]
      _ -> []
    end
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

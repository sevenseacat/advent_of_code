defmodule Y2022.Day22 do
  @moduledoc """
  I am leaving all of my workings in this file because this took me forever and I did it all very
  manually and it was an utter nightmare.

  For part two, I actually drew two shapes on paper, one in the shape of the sample input, and
  one in the shape of the real input, labelled them with what face of the cube they are, cut them
  out, and made them into cubes.

  I then manually looked at each edge, and the coordinates that would cover travelling off each
  edge, and where they would transfer to (and what direction they would now be facing.

  There were lots of mistakes made, including hardcoding all of the numbers (forgetting that the
  size of the real input is not 4x4), mixing up rows and columns, off by one errors, and probably
  more that I'm forgetting.

  I told myself I would reward myself with dessert if I got the right answer. So I'm off to eat
  some chocolate 🍫
  """
  use Advent.Day, no: 22
  alias Advent.PathGrid

  def part1(%{path_grid: %{graph: graph}, moves: moves}) do
    vertices = Graph.vertices(graph)
    start = Enum.min(vertices)

    boundaries = boundaries(vertices)

    transfer_fn = fn {new_position, facing} ->
      {maybe_wrap(new_position, facing, boundaries), facing}
    end

    traverse_grid(graph, moves, {start, :right}, transfer_fn)
    |> calculate_password()
  end

  def part2(%{path_grid: %{graph: graph}, moves: moves}, input_type \\ :real) do
    vertices = Graph.vertices(graph)
    start = Enum.min(vertices)

    transfer_fn = fn new_position -> cube_mapping(new_position, input_type) end

    traverse_grid(graph, moves, {start, :right}, transfer_fn)
    |> calculate_password()
  end

  defp cube_mapping({{row, col}, facing}, :real) do
    size = 50

    cond do
      # # Square 1 - no right or down as that's contiguous
      # {{0, 5}, :up} => {{13, 1}, :right},
      # {{0, 6}, :up} => {{14, 1}, :right},
      # {{0, 7}, :up} => {{15, 1}, :right},
      # {{0, 8}, :up} => {{16, 1}, :right},
      # {{0, col}, :up} when col in (size + 1)..(2 * size) ->
      #  {{4 * size + 1 - 2 * size, 1}, :right}
      facing == :up && row == 0 && col in (size + 1)..(2 * size) ->
        {{col + 2 * size, 1}, :right}

      # {{1, 4}, :left} => {{12, 1}, :right},
      # {{2, 4}, :left} => {{11, 1}, :right},
      # {{3, 4}, :left} => {{10, 1}, :right},
      # {{4, 4}, :left} => {{9, 1}, :right},
      facing == :left && col == size && row in 1..size ->
        {{3 * size + 1 - row, 1}, :right}

      # # Square 2 - no left as that's contiguous
      # {{0, 9}, :up} => {{16, 1}, :up},
      # {{0, 10}, :up} => {{16, 2}, :up},
      # {{0, 11}, :up} => {{16, 3}, :up},
      # {{0, 12}, :up} => {{16, 4}, :up},
      facing == :up && row == 0 && col in (2 * size + 1)..(3 * size) ->
        {{4 * size, col - 2 * size}, :up}

      # {{1, 13}, :right} => {{12, 8}, :left},
      # {{2, 13}, :right} => {{11, 8}, :left},
      # {{3, 13}, :right} => {{10, 8}, :left},
      # {{4, 13}, :right} => {{9, 8}, :left},
      facing == :right && col == 3 * size + 1 && row in 1..size ->
        {{3 * size + 1 - row, 2 * size}, :left}

      # {{5, 9}, :down} => {{5, 8}, :left},
      # {{5, 10}, :down} => {{6, 8}, :left},
      # {{5, 11}, :down} => {{7, 8}, :left},
      # {{5, 12}, :down} => {{8, 8}, :left}
      facing == :down && row == size + 1 && col in (2 * size - 1)..(3 * size) ->
        {{col - size, 2 * size}, :left}

      # # Square 3 - no up or down as that's contiguous
      # {{5, 4}, :left} => {{9, 1}, :down},
      # {{6, 4}, :left} => {{9, 2}, :down},
      # {{7, 4}, :left} => {{9, 3}, :down},
      # {{8, 4}, :left} => {{9, 4}, :down},
      facing == :left && col == size && row in (size + 1)..(2 * size) ->
        {{2 * size + 1, row - size}, :down}

      # {{5, 9}, :right} => {{4, 9}, :up},
      # {{6, 9}, :right} => {{4, 10}, :up},
      # {{7, 9}, :right} => {{4, 11}, :up},
      # {{8, 9}, :right} => {{4, 12}, :up},
      facing == :right && col == 2 * size + 1 && row in (size + 1)..(2 * size) ->
        {{size, size + row}, :up}

      # # Square 4 - no right or down as that's contiguous
      # {{8, 1}, :up} => {{5, 5}, :right},
      # {{8, 2}, :up} => {{6, 5}, :right},
      # {{8, 3}, :up} => {{7, 5}, :right},
      # {{8, 4}, :up} => {{8, 5}, :right},
      facing == :up && row == 2 * size && col in 1..size ->
        {{size + col, size + 1}, :right}

      # {{9, 0}, :left} => {{4, 5}, :right},
      # {{10, 0}, :left} => {{3, 5}, :right},
      # {{11, 0}, :left} => {{2, 5}, :right},
      # {{12, 0}, :left} => {{1, 5}, :right},
      facing == :left && col == 0 && row in (2 * size + 1)..(3 * size) ->
        {{3 * size + 1 - row, size + 1}, :right}

      # # Square 5 - no left or up as that's contiguous
      # {{9, 9}, :right} => {{4, 12}, :left},
      # {{10, 9}, :right} => {{3, 12}, :left},
      # {{11, 9}, :right} => {{2, 12}, :left},
      # {{12, 9}, :right} => {{1, 12}, :left},
      facing == :right && col == 2 * size + 1 && row in (2 * size + 1)..(3 * size) ->
        {{3 * size + 1 - row, 3 * size}, :left}

      # {{13, 5}, :down} => {{13, 4}, :left},
      # {{13, 6}, :down} => {{14, 4}, :left},
      # {{13, 7}, :down} => {{15, 4}, :left},
      # {{13, 8}, :down} => {{16, 4}, :left},
      facing == :down && row == 3 * size + 1 && col in (size + 1)..(2 * size) ->
        {{col + 2 * size, size}, :left}

      # # Square 6 - no up or that's contiguous
      # {{13, 0}, :left} => {{1, 5}, :down},
      # {{14, 0}, :left} => {{1, 6}, :down},
      # {{15, 0}, :left} => {{1, 7}, :down},
      # {{16, 0}, :left} => {{1, 8}, :down},
      facing == :left && col == 0 && row in (3 * size + 1)..(4 * size) ->
        {{1, row - 2 * size}, :down}

      # {{17, 1}, :down} => {{1, 9}, :down},
      # {{17, 2}, :down} => {{1, 10}, :down},
      # {{17, 3}, :down} => {{1, 11}, :down},
      # {{17, 4}, :down} => {{1, 12}, :down}
      facing == :down && row == 4 * size + 1 && col in 1..size ->
        {{1, 2 * size + col}, :down}

      # {{13, 5}, :right} => {{12, 5}, :up},
      # {{14, 5}, :right} => {{12, 6}, :up},
      # {{15, 5}, :right} => {{12, 7}, :up},
      # {{16, 5}, :right} => {{12, 8}, :up}
      facing == :right && col == size + 1 && row in (3 * size + 1)..(4 * size) ->
        {{3 * size, row - 2 * size}, :up}

      true ->
        {{row, col}, facing}
    end
  end

  defp cube_mapping({{row, col}, facing}, :sample) do
    size = 4

    cond do
      # Square 1 - no down as that's contiguous
      # {{1, 13}, :right} => {{12, 16}, :left},
      # {{2, 13}, :right} => {{11, 16}, :left},
      # {{3, 13}, :right} => {{10, 16}, :left},
      # {{4, 13}, :right} => {{9, 16}, :left},
      # {{row, 13}, :right} when row in 1..4 -> {{13 - row, 16}, :left}
      facing == :right && col == 3 * size + 1 && row in 1..size ->
        {{col - row, 4 * size}, :left}

      # {{1, 8}, :left} => {{5, 5}, :down},
      # {{2, 8}, :left} => {{5, 6}, :down},
      # {{3, 8}, :left} => {{5, 7}, :down},
      # {{4, 8}, :left} => {{5, 8}, :down},
      # {{row, 8}, :left} when row in 1..4 -> {{5, row + 4}, :down}
      facing == :left && col == 2 * size && row in 1..size ->
        {{size + 1, row + size}, :down}

      # {{0, 9}, :up} => {{5, 4}, :down},
      # {{0, 10}, :up} => {{5, 3}, :down},
      # {{0, 11}, :up} => {{5, 2}, :down},
      # {{0, 12}, :up} => {{5, 1}, :down},
      # {{0, col}, :up} when col in 9..12 -> {{5, 13 - col}, :down}
      facing == :up && row == 0 && col in (2 * size + 1)..(3 * size) ->
        {{size + 1, 3 * size + 1 - col}, :down}

      # Square 2 - no right as that's contiguous
      # {{4, 1}, :up} => {{1, 12}, :down},
      # {{4, 2}, :up} => {{1, 11}, :down},
      # {{4, 3}, :up} => {{1, 10}, :down},
      # {{4, 4}, :up} => {{1, 9}, :down},
      # {{4, col}, :up} when col in 1..4 -> {{1, 13 - col}, :down}
      facing == :up && row == size && col in 1..size ->
        {{1, 3 * size + 1 - col}, :down}

      # {{5, 0}, :left} => {{12, 16}, :up},
      # {{6, 0}, :left} => {{12, 15}, :up},
      # {{7, 0}, :left} => {{12, 14}, :up},
      # {{8, 0}, :left} => {{12, 13}, :up},
      # {{row, 0}, :left} when row in 5..8 -> {{12, 21 - row}, :up}
      facing == :left && col == 0 && row in (size + 1)..(2 * size) ->
        {{3 * size, 5 * size + 1 - row}, :up}

      # {{9, 1}, :down} => {{12, 12}, :up},
      # {{9, 2}, :down} => {{12, 11}, :up},
      # {{9, 3}, :down} => {{12, 10}, :up},
      # {{9, 4}, :down} => {{12, 9}, :up},
      # {{9, col}, :down} when col in 1..4 -> {{12, 13 - col}, :up}
      facing == :down && row == 2 * size + 1 && col in 1..size ->
        {{3 * size, 3 * size + 1 - col}, :up}

      # Square 3 - no left or right as that's contiguous
      # {{4, 5}, :up} => {{1, 9}, :right},
      # {{4, 6}, :up} => {{2, 9}, :right},
      # {{4, 7}, :up} => {{3, 9}, :right},
      # {{4, 8}, :up} => {{4, 9}, :right},
      # {{4, col}, :up} when col in 5..8 -> {{col - 4, 9}, :right}
      facing == :up && row == size && col in (size + 1)..(2 * size) ->
        {{col - size, 2 * size + 1}, :right}

      # {{9, 5}, :down} => {{12, 9}, :right},
      # {{9, 6}, :down} => {{11, 9}, :right},
      # {{9, 7}, :down} => {{10, 9}, :right},
      # {{9, 8}, :down} => {{9, 9}, :right},
      # {{9, col}, :down} when col in 5..8 -> {{17 - col, 9}, :right}
      facing == :down && row == 2 * size + 1 && col in (size + 1)..(2 * size) ->
        {{4 * size + 1 - col, 2 * size + 1}, :right}

      # Square 4 - no up, left or down as that's contiguous
      # {{5, 13}, :right} => {{9, 16}, :down},
      # {{6, 13}, :right} => {{9, 15}, :down},
      # {{7, 13}, :right} => {{9, 14}, :down},
      # {{8, 13}, :right} => {{9, 13}, :down},
      # {{row, 13}, :right} when row in 5..8 -> {{9, 21 - row}, :down}
      facing == :right && col == 3 * size + 1 && row in (size + 1)..(2 * size) ->
        {{2 * size + 1, 5 * size + 1 - row}, :down}

      # Square 5 - no up or right as that's contiguous
      # {{9, 8}, :left} => {{8, 8}, :up},
      # {{10, 8}, :left} => {{8, 7}, :up},
      # {{11, 8}, :left} => {{8, 6}, :up},
      # {{12, 8}, :left} => {{8, 5}, :up},
      # {{row, 8}, :left} when row in 9..12 -> {{8, 17 - row}, :up}
      facing == :left && col == 2 * size && row in (2 * size + 1)..(3 * size) ->
        {{2 * size, 4 * size + 1 - row}, :up}

      # {{13, 9}, :down} => {{8, 4}, :up},
      # {{13, 10}, :down} => {{8, 3}, :up},
      # {{13, 11}, :down} => {{8, 2}, :up},
      # {{13, 12}, :down} => {{8, 1}, :up},
      # {{13, col}, :down} when col in 9..12 -> {{8, 13 - col}, :up}
      facing == :down && row == 3 * size + 1 && col in (2 * size + 1)..(3 * size) ->
        {{2 * size, 3 * size + 1 - col}, :up}

      # Square 6 - no left as that's contiguous
      # {{8, 13}, :up} => {{8, 12}, :left},
      # {{8, 14}, :up} => {{7, 12}, :left},
      # {{8, 15}, :up} => {{6, 12}, :left},
      # {{8, 16}, :up} => {{5, 12}, :left},
      # {{8, col}, :up} when col in 13..16 -> {{21 - col, 12}, :left}
      facing == :up && row == 2 * size && col == (3 * size + 1)..(4 * size) ->
        {{5 * size + 1 - col, 3 * size}, :left}

      # {{9, 17}, :right} => {{4, 12}, :left},
      # {{10, 17}, :right} => {{3, 12}, :left},
      # {{11, 17}, :right} => {{2, 12}, :left},
      # {{12, 17}, :right} => {{1, 12}, :left},
      # {{row, 17}, :right} when row in 9..12 -> {{13 - row, 12}, :left}
      facing == :right && col == 4 * size + 1 && row in (2 * size + 1)..(3 * size) ->
        {{3 * size + 1 - row, 3 * size}, :left}

      # {{13, 13}, :down} => {{8, 1}, :right},
      # {{13, 14}, :down} => {{7, 1}, :right},
      # {{13, 15}, :down} => {{6, 1}, :right},
      # {{13, 16}, :down} => {{5, 1}, :right}
      # {{13, col}, :down} when col in 13..16 -> {{21 - col, 1}, :right}
      facing == :down && row == 3 * size + 1 && col in (3 * size + 1)..(4 * size) ->
        {{5 * size + 1 - col, 1}, :right}

      true ->
        {{row, col}, facing}
    end
  end

  defp traverse_grid(_graph_data, [], current, _transfer_fn), do: current

  defp traverse_grid(graph_data, [move | moves], current, transfer_fn) do
    traverse_grid(graph_data, moves, move(graph_data, current, move, transfer_fn), transfer_fn)
  end

  defp move(_graph_data, {position, facing}, dir, _transfer_fn) when dir in ["L", "R"] do
    {position, turn(facing, dir)}
  end

  defp move(_graph_data, current, 0, _transfer_fn), do: current

  defp move(graph, current, num, transfer_fn) do
    {next_position, facing} = transfer_fn.(forward(current))

    if PathGrid.wall?(graph, next_position) do
      current
    else
      move(graph, {next_position, facing}, num - 1, transfer_fn)
    end
  end

  defp forward({{row, col}, :up}), do: {{row - 1, col}, :up}
  defp forward({{row, col}, :down}), do: {{row + 1, col}, :down}
  defp forward({{row, col}, :left}), do: {{row, col - 1}, :left}
  defp forward({{row, col}, :right}), do: {{row, col + 1}, :right}

  defp turn(:left, "L"), do: :down
  defp turn(:left, "R"), do: :up
  defp turn(:up, "L"), do: :left
  defp turn(:up, "R"), do: :right
  defp turn(:down, "L"), do: :right
  defp turn(:down, "R"), do: :left
  defp turn(:right, "L"), do: :up
  defp turn(:right, "R"), do: :down

  defp maybe_wrap({row, col}, dir, %{cols: cols}) when dir in [:up, :down] do
    {min_row, max_row} = Map.fetch!(cols, col)

    cond do
      row < min_row -> {max_row, col}
      row > max_row -> {min_row, col}
      true -> {row, col}
    end
  end

  defp maybe_wrap({row, col}, dir, %{rows: rows}) when dir in [:left, :right] do
    {min_col, max_col} = Map.fetch!(rows, row)

    cond do
      col < min_col -> {row, max_col}
      col > max_col -> {row, min_col}
      true -> {row, col}
    end
  end

  defp boundaries(vertices) do
    {{min_row, _}, {max_row, _}} = Enum.min_max_by(vertices, fn {row, _} -> row end)
    {{_, min_col}, {_, max_col}} = Enum.min_max_by(vertices, fn {_, col} -> col end)

    row_data =
      Enum.reduce(min_row..max_row, %{}, fn row, acc ->
        {{_, min_col}, {_, max_col}} =
          Enum.filter(vertices, fn {row_no, _} -> row_no == row end)
          |> Enum.min_max_by(fn {_, col_no} -> col_no end)

        Map.put(acc, row, {min_col, max_col})
      end)

    col_data =
      Enum.reduce(min_col..max_col, %{}, fn col, acc ->
        {{min_row, _}, {max_row, _}} =
          Enum.filter(vertices, fn {_, col_no} -> col_no == col end)
          |> Enum.min_max_by(fn {row_no, _} -> row_no end)

        Map.put(acc, col, {min_row, max_row})
      end)

    %{rows: row_data, cols: col_data}
  end

  defp calculate_password({{row, col}, facing}) do
    facing_scores = %{up: 3, left: 2, right: 0, down: 1}
    1000 * row + 4 * col + Map.fetch!(facing_scores, facing)
  end

  def parse_input(input) do
    [grid, moves] = input |> String.trim_trailing() |> String.split("\n\n", trim: true)

    %{
      path_grid: PathGrid.new(grid),
      moves: moves |> String.trim() |> String.graphemes() |> parse_moves()
    }
  end

  defp parse_moves(list, tmp \\ [], acc \\ [])

  defp parse_moves([one], tmp, acc) do
    [collect([String.to_integer(one) | tmp]) | acc] |> Enum.reverse()
  end

  defp parse_moves([a, b | rest], tmp, acc) when a in ["R", "L"] do
    parse_moves([b | rest], [], [a, collect(tmp) | acc])
  end

  defp parse_moves([a, b | rest], tmp, acc) do
    parse_moves([b | rest], [String.to_integer(a) | tmp], acc)
  end

  defp collect(list), do: list |> Enum.reverse() |> Integer.undigits()

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end

defmodule Y2022.Day22 do
  use Advent.Day, no: 22
  alias Advent.PathGrid

  def part1(%{path_grid: %{graph: graph}, moves: moves}) do
    vertices = Graph.vertices(graph)
    start = Enum.min(vertices)

    boundaries = boundaries(vertices)

    transfer_fn = fn {_old_pos, facing}, {new_pos, facing} ->
      {maybe_wrap(new_pos, facing, boundaries), facing}
    end

    traverse_grid(graph, moves, {start, :right}, transfer_fn)
    |> calculate_password()
  end

  def part2(input) do
    input
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
    {next_position, facing} = transfer_fn.(current, forward(current))

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
  # def part2_verify, do: input() |> parse_input() |> part2()
end

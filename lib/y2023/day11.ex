defmodule Y2023.Day11 do
  use Advent.Day, no: 11
  alias Advent.Grid

  def part1(input) do
    {graph, units} =
      input
      |> expand_grid()
      |> build_graph()

    units
    |> Advent.permutations(2)
    |> Enum.map(&Enum.sort/1)
    |> Enum.uniq()
    |> Task.async_stream(fn [from, to] ->
      path = Graph.dijkstra(graph, from, to)
      length(path) - 1
    end)
    |> Enum.map(fn {:ok, val} -> val end)
    |> Enum.sum()
  end

  # @doc """
  # iex> Day11.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  def parse_input(input) do
    grid = Grid.new(input)

    units =
      grid
      |> Enum.filter(fn {_coord, val} -> val == "#" end)
      |> Enum.map(&elem(&1, 0))

    {row, col} = Grid.size(grid)

    {grid, units, %{rows: MapSet.new(1..row), cols: MapSet.new(1..col)}}
  end

  defp expand_grid({grid, units, %{rows: rows, cols: cols}}) do
    grid = double_grid_coords(grid)
    rows = double_values(rows)
    cols = double_values(cols)
    units = Enum.map(units, &double_coord/1)

    {grid, rows} =
      rows
      |> Enum.reduce({grid, rows}, fn row, {grid, rows} ->
        # The row is empty - add another row in between
        if Enum.all?(cols, fn col -> Map.fetch!(grid, {row, col}) == "." end) do
          grid =
            Enum.reduce(cols, grid, fn col, grid ->
              Map.put(grid, {row + 1, col}, ".")
            end)

          {grid, [row + 1 | rows]}
        else
          {grid, rows}
        end
      end)

    # Do the same thing for cols
    {grid, cols} =
      cols
      |> Enum.reduce({grid, cols}, fn col, {grid, cols} ->
        # The col is empty - add another col in between
        if Enum.all?(rows, fn row -> Map.fetch!(grid, {row, col}) == "." end) do
          grid =
            Enum.reduce(rows, grid, fn row, grid ->
              Map.put(grid, {row, col + 1}, ".")
            end)

          {grid, [col + 1 | cols]}
        else
          {grid, cols}
        end
      end)

    {grid, units, %{rows: MapSet.new(rows), cols: MapSet.new(cols)}}
  end

  defp double_grid_coords(grid) do
    grid
    |> Enum.map(fn {coord, val} -> {double_coord(coord), val} end)
    |> Enum.into(%{})
  end

  defp double_coord({row, col}), do: {row * 2, col * 2}

  defp double_values(mapset) do
    mapset
    |> MapSet.to_list()
    |> Enum.map(&(&1 * 2))
  end

  defp build_graph({_grid, units, %{rows: rows, cols: cols}}) do
    graph =
      for row <- rows, col <- cols do
        {row, col}
      end
      |> Enum.reduce(Graph.new(vertex_identifier: & &1), fn {row, col}, graph ->
        graph
        |> Graph.add_vertex({row, col})
        |> add_edge({row, col}, {previous(rows, row), col})
        |> add_edge({row, col}, {row, previous(cols, col)})
      end)

    {graph, units}
  end

  defp add_edge(graph, _coord, {row, col}) when is_nil(row) or is_nil(col) do
    graph
  end

  defp add_edge(graph, from, to) do
    graph
    |> Graph.add_edge(from, to)
    |> Graph.add_edge(to, from)
  end

  def previous(set, max) do
    Enum.max_by(set, fn val -> if val < max, do: val, else: 0 end)
  end

  # def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end

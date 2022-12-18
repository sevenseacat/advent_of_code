defmodule Advent.PathGrid.Unit do
  defstruct identifier: nil, position: nil
end

defmodule Advent.PathGrid do
  defstruct graph: nil, units: []

  alias Advent.PathGrid.Unit

  @doc """
  Parses the raw input as read from the input text file, eg.

  ```
  ###########
  #0.1.....2#
  #.#######.#
  #4.......3#
  ###########
  ```

  AOC consistently designs grids in the same way - impassable walls with `#`, and
  traversable spaces with `.`.

  Any other characters are designated as "units", and will have their identifiers/positions
  stored for later usage.
  """
  def new(input) do
    {graph, units, _row} =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce({Graph.new(), [], 1}, &parse_row/2)

    %__MODULE__{graph: graph, units: units}
  end

  defp parse_row(row, {graph, units, row_num}) do
    {graph, units, _col_num} =
      row
      |> String.graphemes()
      |> Enum.reduce({graph, units, 1}, fn char, {graph, units, col_num} ->
        units = parse_unit(char, units, row_num, col_num)
        graph = parse_coord(char, graph, row_num, col_num)
        {graph, units, col_num + 1}
      end)

    {graph, units, row_num + 1}
  end

  defp parse_unit("#", units, _row, _col), do: units
  defp parse_unit(".", units, _row, _col), do: units

  defp parse_unit(unit, units, row, col) do
    [%Unit{identifier: unit, position: {row, col}} | units]
  end

  defp parse_coord("#", graph, _, _), do: graph

  defp parse_coord(_, graph, row, col) do
    graph = Graph.add_vertex(graph, {row, col})

    [{row - 1, col}, {row, col - 1}]
    |> Enum.reduce(graph, fn neighbour, graph ->
      if Graph.has_vertex?(graph, neighbour) do
        graph
        |> Graph.add_edge({row, col}, neighbour)
        |> Graph.add_edge(neighbour, {row, col})
      else
        graph
      end
    end)
  end
end

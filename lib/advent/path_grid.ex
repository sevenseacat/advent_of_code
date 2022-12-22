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
      |> String.split("\n")
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

  defp parse_unit(unit, units, _row, _col) when unit in ["#", ".", " "], do: units

  defp parse_unit(unit, units, row, col) do
    [%Unit{identifier: unit, position: {row, col}} | units]
  end

  defp parse_coord(" ", graph, _, _), do: graph

  defp parse_coord(char, graph, row, col) do
    coord_type = if char == "#", do: :wall, else: :floor
    graph = Graph.add_vertex(graph, {row, col}, coord_type)

    [{row - 1, col}, {row, col - 1}]
    |> Enum.reduce(graph, fn neighbour, graph ->
      if floor?(graph, neighbour) do
        graph
        |> Graph.add_edge({row, col}, neighbour)
        |> Graph.add_edge(neighbour, {row, col})
      else
        graph
      end
    end)
  end

  def display(graph, units \\ []) do
    vertices = Graph.vertices(graph)
    {{min_row, _}, {max_row, _}} = Enum.min_max_by(vertices, fn {row, _} -> row end) |> dbg
    {{_, min_col}, {_, max_col}} = Enum.min_max_by(vertices, fn {_, col} -> col end) |> dbg

    for row <- min_row..max_row, col <- min_col..max_col do
      if unit = Enum.find(units, fn unit -> unit.position == {row, col} end) do
        unit.type
      else
        cond do
          floor?(graph, {row, col}) -> "."
          wall?(graph, {row, col}) -> "#"
          true -> " "
        end
      end
    end
    |> Enum.chunk_every(max_col - min_col + 1)
    |> Enum.map(&List.to_string/1)
    |> Enum.map(&IO.puts/1)

    graph
  end

  def wall?(graph, coordinate) do
    Graph.has_vertex?(graph, coordinate) && Graph.vertex_labels(graph, coordinate) == [:wall]
  end

  def floor?(graph, coordinate) do
    Graph.has_vertex?(graph, coordinate) && Graph.vertex_labels(graph, coordinate) == [:floor]
  end

  def floor_spaces(graph) do
    Graph.vertices(graph)
    |> Enum.filter(fn v -> Graph.vertex_labels(graph, v) == [:floor] end)
  end
end

defmodule Advent.Grid do
  def new(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(Map.new(), &parse_row/2)
  end

  defp parse_row({row, row_no}, map) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(map, fn {col, col_no}, map ->
      Map.put(map, {row_no + 1, col_no + 1}, col)
    end)
  end

  def display(grid, highlight \\ nil) do
    vertices = Map.keys(grid)
    {{min_row, min_col}, {max_row, max_col}} = Enum.min_max(vertices)

    for row <- min_row..max_row, col <- min_col..max_col do
      if {row, col} == highlight do
        "E"
      else
        list = Map.fetch!(grid, {row, col})
        if(length(list) > 1, do: "#{length(list)}", else: hd(list))
      end
    end
    |> Enum.chunk_every(max_col - min_col + 1)
    |> Enum.map(&List.to_string/1)
    |> Enum.map(&IO.puts/1)

    grid
  end
end

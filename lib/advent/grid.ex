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
      Map.put(map, {row_no, col_no}, col)
    end)
  end
end

defmodule Y2018.Day13 do
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, &parse_row/2)
  end

  defp parse_row({row, num}, grid) do
    row
    |> String.graphemes()
    |> Enum.reduce({grid, 0}, fn char, {grid, col} ->
      {add_char_to_grid(grid, char, {col, num}), col + 1}
    end)
    |> elem(0)
  end

  defp add_char_to_grid(grid, char, {col, row}) do
    val =
      case char do
        " " -> nil
        "^" -> {"|", :up}
        "v" -> {"|", :down}
        "<" -> {"-", :left}
        ">" -> {"-", :right}
        c -> {c, nil}
      end

    if val != nil do
      Map.put(grid, {col, row}, val)
    else
      grid
    end
  end
end

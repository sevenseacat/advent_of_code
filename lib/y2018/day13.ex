defmodule Y2018.Day13 do
  def part1(input) do
    input
    |> parse_input
    |> run_until_crash(0)
  end

  def run_until_crash(input, tick) do
    tick(input)

    case crashed?(input) do
      false -> run_until_crash(input, tick + 1)
      result -> result
    end
  end

  def tick(input) do
    input
  end

  def crashed?(input) do
    true
  end

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
        "^" -> {"|", {:up, :left}}
        "v" -> {"|", {:down, :left}}
        "<" -> {"-", {:left, :left}}
        ">" -> {"-", {:right, :left}}
        c -> {c, nil}
      end

    if val != nil do
      Map.put(grid, {col, row}, val)
    else
      grid
    end
  end
end

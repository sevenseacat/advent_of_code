defmodule Y2021.Day05 do
  use Advent.Day, no: 5

  def parts(input) do
    input
    |> List.flatten()
    |> Enum.frequencies()
    |> Enum.count(fn {_val, count} -> count > 1 end)
  end

  def parse_input(input, include_diagonals \\ false) do
    input
    |> String.split("\n")
    |> Enum.map(fn row -> parse_row(row, include_diagonals) end)
    |> Enum.reject(&is_nil/1)
  end

  defp parse_row(row, include_diagonals) do
    row
    |> String.trim()
    |> String.split([",", " -> "])
    |> Enum.map(&String.to_integer/1)
    |> to_grid(include_diagonals)
  end

  def to_grid([x, y1, x, y2], _include_diagonals), do: for(y <- y1..y2, do: {x, y})
  def to_grid([x1, y, x2, y], _include_diagonals), do: for(x <- x1..x2, do: {x, y})
  def to_grid(_, false), do: nil

  def to_grid([x1, y1, x2, y2], true) do
    x_mult = to_mult(x1, x2)
    y_mult = to_mult(y1, y2)
    for i <- 0..abs(x2 - x1), do: {x1 + i * x_mult, y1 + i * y_mult}
  end

  def to_mult(val1, val2), do: if(val1 < val2, do: 1, else: -1)

  def part1_verify, do: input() |> parse_input(false) |> parts()
  def part2_verify, do: input() |> parse_input(true) |> parts()
end

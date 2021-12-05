defmodule Y2021.Day05 do
  use Advent.Day, no: 5

  def part1(input) do
    input
    |> List.flatten()
    |> Enum.frequencies()
    |> Enum.count(fn {_val, count} -> count > 1 end)
  end

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_row/1)
    |> Enum.reject(&is_nil/1)
  end

  defp parse_row(row) do
    row
    |> String.split([",", " -> "])
    |> Enum.map(&String.to_integer/1)
    |> to_grid()
  end

  def to_grid([x, y1, x, y2]), do: for(y <- y1..y2, do: {x, y})
  def to_grid([x1, y, x2, y]), do: for(x <- x1..x2, do: {x, y})

  # Diagonal lines - ignore for part 1
  def to_grid(_), do: nil

  def part1_verify, do: input() |> parse_input() |> part1()
end

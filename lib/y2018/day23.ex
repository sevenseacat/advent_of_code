defmodule Y2018.Day23 do
  use Advent.Day, no: 23

  @row_regex ~r/pos=<(?<x>-?\d+),(?<y>-?\d+),(?<z>-?\d+)>, r=(?<r>\d+)/

  @doc """
  iex> Day23.part1([%{x: 0, y: 0, z: 0, r: 4}, %{x: 1, y: 0, z: 0, r: 1},
  ...>   %{x: 4, y: 0, z: 0, r: 3}, %{x: 0, y: 2, z: 0, r: 1},
  ...>   %{x: 0, y: 5, z: 0, r: 3}, %{x: 0, y: 0, z: 3, r: 1},
  ...>   %{x: 1, y: 1, z: 1, r: 1}, %{x: 1, y: 1, z: 2, r: 1},
  ...>   %{x: 1, y: 3, z: 1, r: 1}])
  {%{r: 4, x: 0, y: 0, z: 0}, 7}
  """
  def part1(bots) do
    best_bot = Enum.max_by(bots, fn %{r: r} -> r end)

    {best_bot, Enum.count(bots, fn bot -> within_radius?(best_bot, bot) end)}
  end

  defp within_radius?(%{x: x1, y: y1, z: z1, r: r}, %{x: x2, y: y2, z: z2}) do
    abs(x1 - x2) + abs(y1 - y2) + abs(z1 - z2) <= r
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(row) do
    string_row = Regex.named_captures(@row_regex, row)
    for {key, val} <- string_row, into: %{}, do: {String.to_atom(key), String.to_integer(val)}
  end

  def part1_verify, do: input() |> parse_input() |> part1() |> elem(1)
end

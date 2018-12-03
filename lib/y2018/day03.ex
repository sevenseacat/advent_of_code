defmodule Y2018.Day03 do
  use Advent.Day, no: 3

  @row_regex ~r/#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<width>\d+)x(?<height>\d+)/

  @doc """
  iex> Day03.part1("#1 @ 1,3: 4x4\\n#2 @ 3,1: 4x4\\n#3 @ 5,5: 2x2")
  4
  """
  def part1(input) do
    input
    |> parse_input
    |> Enum.reduce(Map.new(), &add_claim_to_fabric/2)
    |> Enum.count(fn {_, v} -> length(v) > 1 end)
  end

  @doc """
  iex> Day03.add_claim_to_fabric(%{id: 3, x: 5, y: 5, width: 2, height: 2}, %{})
  %{{5, 5} => [3], {5, 6} => [3], {6, 5} => [3], {6, 6} => [3]}
  """
  def add_claim_to_fabric(claim, fabric) do
    Enum.reduce(coordinates_of_claim(claim), fabric, fn coord, acc ->
      Map.update(acc, coord, [claim[:id]], &[claim[:id] | &1])
    end)
  end

  defp coordinates_of_claim(claim) do
    for x <- claim[:x]..(claim[:x] + claim[:width] - 1),
        y <- claim[:y]..(claim[:y] + claim[:height] - 1),
        do: {x, y}
  end

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(row) do
    string_row = Regex.named_captures(@row_regex, row)
    for {key, val} <- string_row, into: %{}, do: {String.to_atom(key), String.to_integer(val)}
  end

  def part1_verify, do: input() |> part1()
end

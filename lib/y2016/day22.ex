defmodule Y2016.Day22 do
  use Advent.Day, no: 22

  def part1(list) do
    list
    |> Enum.map(fn row -> count_matches(row, list) end)
    |> Enum.sum()
  end

  defp count_matches(%{used: 0}, _), do: 0

  defp count_matches(row, list) do
    list
    |> Enum.filter(fn l -> l != row && l.available >= row.used end)
    |> length
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.drop(2)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(row) do
    ~r/\/dev\/grid\/node-x(?<x>\d+)-y(?<y>\d+)(\s+)(?<size>\d+)T(\s+)(?<used>\d+)T(\s+)(?<available>\d+)T(\s+)(?<use>\d+)%/
    |> Regex.named_captures(row)
    |> Enum.map(fn {key, val} -> {String.to_atom(key), String.to_integer(val)} end)
    |> Map.new()
  end

  def part1_verify, do: input() |> parse_input() |> part1()
end

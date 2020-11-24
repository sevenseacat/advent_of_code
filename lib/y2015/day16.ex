defmodule Y2015.Day16 do
  use Advent.Day, no: 16

  @tape %{
    "children" => 3,
    "cats" => 7,
    "samoyeds" => 2,
    "pomeranians" => 3,
    "akitas" => 0,
    "vizslas" => 0,
    "goldfish" => 5,
    "trees" => 3,
    "cars" => 2,
    "perfumes" => 1
  }

  def part1(input, tape \\ @tape) do
    input
    |> parse_input
    |> find_matching_sue(tape)
  end

  defp find_matching_sue(sues, rules) do
    sues
    |> Enum.find(fn {_no, attrs} ->
      Enum.all?(attrs, fn {attr, val} -> attr_matching?(attr, val, rules) end)
    end)
  end

  defp attr_matching?(attr, val, rules) do
    if Map.has_key?(rules, attr) do
      Map.get(rules, attr) == val
    else
      true
    end
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(row) do
    [sue_no, attrs] = String.split(row, ": ", parts: 2)

    attrs =
      attrs
      |> String.split(", ")
      |> Enum.map(&parse_attr/1)
      |> Enum.into(%{})

    {sue_no, attrs}
  end

  defp parse_attr(attr) do
    [name, num] = String.split(attr, ": ")
    {name, String.to_integer(num)}
  end

  def part1_verify, do: input() |> part1() |> elem(0)
end

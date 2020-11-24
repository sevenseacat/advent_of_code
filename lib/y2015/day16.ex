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
    |> find_matching_sue(tape, &eql_matching?/3)
  end

  def part2(input, tape \\ @tape) do
    input
    |> parse_input
    |> find_matching_sue(tape, &range_matching?/3)
  end

  defp find_matching_sue(sues, rules, matching_fn) do
    sues
    |> Enum.find(fn {_no, attrs} ->
      Enum.all?(attrs, fn {attr, val} -> matching_fn.(attr, val, rules) end)
    end)
  end

  defp eql_matching?(attr, val, rules) do
    if Map.has_key?(rules, attr) do
      Map.get(rules, attr) == val
    else
      true
    end
  end

  defp range_matching?(attr, val, rules) do
    if Map.has_key?(rules, attr) do
      Kernel.apply(Kernel, range_op(attr), [val, Map.get(rules, attr)])
    else
      true
    end
  end

  defp range_op(attr) when attr == "cats" or attr == "trees", do: :>
  defp range_op(attr) when attr == "pomeranians" or attr == "goldfish", do: :<
  defp range_op(_attr), do: :==

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
  def part2_verify, do: input() |> part2() |> elem(0)
end

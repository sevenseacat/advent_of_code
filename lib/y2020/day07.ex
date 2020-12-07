defmodule Y2020.Day07 do
  use Advent.Day, no: 7

  @doc """
  iex> Day07.part1(%{
  ...>  "bright white" => %{"shiny gold" => 1},
  ...>  "dark olive" => %{"dotted black" => 4, "faded blue" => 3},
  ...>  "dark orange" => %{"bright white" => 3, "muted yellow" => 4},
  ...>  "dotted black" => %{},
  ...>  "faded blue" => %{},
  ...>  "light red" => %{"bright white" => 1, "muted yellow" => 2},
  ...>  "muted yellow" => %{"faded blue" => 9, "shiny gold" => 2},
  ...>  "shiny gold" => %{"dark olive" => 1, "vibrant plum" => 2},
  ...>  "vibrant plum" => %{"dotted black" => 6, "faded blue" => 5}
  ...> })
  4
  """
  def part1(input, target \\ "shiny gold") do
    input
    |> Enum.reduce(Graph.new(), &add_to_graph/2)
    |> Graph.reaching_neighbors([target])
    |> length
  end

  defp add_to_graph({outer, inner}, graph) do
    Enum.reduce(inner, graph, fn {name, count}, acc ->
      Graph.add_edge(acc, Graph.Edge.new(outer, name, weight: count))
    end)
  end

  @doc """
  iex> Day07.part2(:parsed_input)
  :ok
  """
  def part2(_input) do
    :ok
  end

  @doc """
  iex> Day07.parse_input("light red bags contain 1 bright white bag, 2 muted yellow bags.
  ...>dark orange bags contain 3 bright white bags, 4 muted yellow bags.
  ...>")
  %{
    "light red" => %{"bright white" => 1, "muted yellow" => 2},
    "dark orange" => %{"bright white" => 3, "muted yellow" => 4}
  }
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, &parse_row/2)
  end

  defp parse_row(row, acc) do
    [outer, inner] = String.split(row, " bags contain ", parts: 2)
    Map.put(acc, outer, parse_inner(inner))
  end

  defp parse_inner(string) do
    string
    |> String.split(", ")
    |> Enum.reduce(%{}, &parse_inner/2)
  end

  defp parse_inner("no other bags.", acc), do: acc

  defp parse_inner(string, acc) do
    [number, descriptor, colour | _rest] = String.split(string, " ")
    Map.put(acc, "#{descriptor} #{colour}", String.to_integer(number))
  end

  def part1_verify, do: input() |> parse_input() |> part1()
end

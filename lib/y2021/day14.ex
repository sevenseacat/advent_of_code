defmodule Y2021.Day14 do
  use Advent.Day, no: 14

  def part1({input, rules}, count) do
    {{_, min}, {_, max}} =
      input
      |> String.graphemes()
      |> pair_insertion(rules, count)
      |> Enum.frequencies()
      |> Enum.min_max_by(fn {_, count} -> count end)

    max - min
  end

  def pair_insertion(input, _rules, 0), do: input

  def pair_insertion(input, rules, count) do
    iterate_over(input, rules) |> pair_insertion(rules, count - 1)
  end

  defp iterate_over([a], _rules), do: [a]

  defp iterate_over([a, b | rest], rules) do
    replacement = Map.get(rules, "#{a}#{b}")
    [a, replacement | iterate_over([b | rest], rules)]
  end

  def parse_input(input) do
    [source, rules] = String.split(input, "\n\n", trim: true)

    rules =
      for rule <- String.split(rules, "\n", trim: true),
          into: %{},
          do: String.split(rule, " -> ") |> List.to_tuple()

    {source, rules}
  end

  def part1_verify, do: input() |> parse_input() |> part1(10)
end

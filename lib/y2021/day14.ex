defmodule Y2021.Day14 do
  use Advent.Day, no: 14

  def parts({input, rules}, count) do
    {{_, min}, {_, max}} =
      input
      |> String.graphemes()
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.frequencies()
      |> pair_insertion(rules, count)
      |> to_individuals()
      |> Enum.min_max_by(fn {_, count} -> count end)

    max - min
  end

  def pair_insertion(frequencies, _rules, 0), do: frequencies

  def pair_insertion(frequencies, rules, count) do
    Enum.reduce(frequencies, %{}, fn {[left, right], count}, acc ->
      middle = Map.get(rules, "#{left}#{right}")

      acc
      |> Map.update([left, middle], count, &(&1 + count))
      |> Map.update([middle, right], count, &(&1 + count))
    end)
    |> Enum.into(%{})
    |> pair_insertion(rules, count - 1)
  end

  defp to_individuals(frequencies) do
    Enum.reduce(frequencies, %{}, fn
      {[left, right, count]}, %{} ->
        %{left => count, right => count}

      {[_left, right], count}, acc ->
        Map.update(acc, right, count, &(&1 + count))
    end)
  end

  def parse_input(input) do
    [source, rules] = String.split(input, "\n\n", trim: true)

    rules =
      for rule <- String.split(rules, "\n", trim: true),
          into: %{},
          do: String.split(rule, " -> ") |> List.to_tuple()

    {source, rules}
  end

  def part1_verify, do: input() |> parse_input() |> parts(10)
  def part2_verify, do: input() |> parse_input() |> parts(40)
end

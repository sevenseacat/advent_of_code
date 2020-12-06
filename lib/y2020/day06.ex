defmodule Y2020.Day06 do
  use Advent.Day, no: 6

  @doc """
  iex> Day06.part1([[MapSet.new(["a"]), MapSet.new(["b"]), MapSet.new(["c"])],
  ...>             [MapSet.new(["a", "b"]), MapSet.new(["a", "c"])]])
  6
  """
  def part1(input) do
    input
    |> Stream.map(&combine_answers/1)
    |> Stream.map(&MapSet.size/1)
    |> Enum.sum()
  end

  defp combine_answers(group) do
    Enum.reduce(group, MapSet.new(), fn person, acc ->
      MapSet.union(acc, person)
    end)
  end

  @doc """
  iex> Day06.parse_input("a
  ...>b
  ...>c
  ...>
  ...>ab
  ...>ac
  ...>")
  [
    [MapSet.new(["a"]), MapSet.new(["b"]), MapSet.new(["c"])],
    [MapSet.new(["a", "b"]), MapSet.new(["a", "c"])]
  ]
  """
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.reduce([], &process_group/2)
    |> Enum.reverse()
  end

  defp process_group([""], acc), do: acc

  defp process_group(group, acc) do
    [Enum.map(group, &process_person/1) | acc]
  end

  defp process_person(person) do
    person
    |> String.graphemes()
    |> MapSet.new()
  end

  def part1_verify, do: input() |> parse_input() |> part1()
end

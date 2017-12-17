defmodule Y2017.Day13 do
  use Advent.Day, no: 13

  alias Y2017.Day13.Layer

  @doc """
  iex> Day13.part1(%{0 => %Layer{range: 3}, 1 => %Layer{range: 2}, 4 => %Layer{range: 4},
  ...> 6 => %Layer{range: 4}})
  24
  """
  def part1(input) do
    layer_count = Map.keys(input) |> Enum.max()

    move(input, 0, layer_count)
    |> Enum.filter(fn {_, v} -> v.caught end)
    |> Enum.reduce(0, fn {k, v}, acc -> acc + k * v.range end)
  end

  def move(input, current, last) when current > last, do: input

  def move(input, current, last) do
    input
    |> mark_caught!(current)
    |> move_sentries
    |> move(current + 1, last)
  end

  defp mark_caught!(input, current) do
    case Map.has_key?(input, current) do
      true -> Map.update!(input, current, &%{&1 | caught: &1.position == 0})
      false -> input
    end
  end

  defp move_sentries(input) do
    input
    |> Enum.map(fn {k, v} -> {k, Layer.move_sentry(v)} end)
    |> Enum.into(%{})
  end

  @doc """
  iex> Day13.parse_input("0: 3
  ...>1: 2
  ...>4: 4
  ...>6: 4")
  %{0 => %Layer{range: 3}, 1 => %Layer{range: 2}, 4 => %Layer{range: 4}, 6 => %Layer{range: 4}}
  """
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.reduce(%{}, fn row, acc ->
      {depth, layer} = Layer.new(row)
      Map.put(acc, depth, layer)
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
end

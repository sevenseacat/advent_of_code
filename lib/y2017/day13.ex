defmodule Y2017.Day13 do
  use Advent.Day, no: 13

  alias Y2017.Day13.Layer

  @doc """
  iex> Day13.part1([%Layer{depth: 0, range: 3}, %Layer{depth: 1, range: 2},
  ...> %Layer{depth: 4, range: 4}, %Layer{depth: 6, range: 4}])
  24
  """
  def part1(input) do
    layer_count = input |> List.last() |> Map.fetch!(:depth)

    input
    |> move(0, 0, layer_count)
    |> Enum.filter(& &1.caught)
    |> Enum.reduce(0, fn layer, acc -> acc + layer.depth * layer.range end)
  end

  @doc """
  iex> Day13.part2([%Layer{depth: 0, range: 3}, %Layer{depth: 1, range: 2},
  ...> %Layer{depth: 4, range: 4}, %Layer{depth: 6, range: 4}])
  10
  """
  def part2(input) do
    do_part2(input, 0, input |> List.last() |> Map.fetch!(:depth))
  end

  def do_part2(input, offset, layer_count) do
    if offset > 0 && rem(offset, 1000) == 0, do: IO.puts(offset)
    new_input = move(input, offset, 0, layer_count)

    if Enum.any?(new_input, & &1.caught) do
      do_part2(input, offset + 1, layer_count)
    else
      offset
    end
  end

  def move(input, _, current, last) when current > last, do: input

  def move(input, offset, current, last) do
    input
    |> move_sentries(current + offset)
    |> mark_caught!(current)
    |> move(offset, current + 1, last)
  end

  defp mark_caught!(input, current) do
    input
    |> Enum.map(fn layer ->
      if layer.depth == current do
        %{layer | caught: layer.position == 0}
      else
        layer
      end
    end)
  end

  defp move_sentries(input, offset) do
    Enum.map(input, &Layer.set_position(&1, offset))
  end

  @doc """
  iex> Day13.parse_input("0: 3
  ...>1: 2
  ...>4: 4
  ...>6: 4")
  [%Layer{depth: 0, range: 3}, %Layer{depth: 1, range: 2}, %Layer{depth: 4, range: 4},
  %Layer{depth: 6, range: 4}]
  """
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(&Layer.new/1)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
